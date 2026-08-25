package de.huluvu.developer_wiki_source_capture

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.UUID

class MainActivity : FlutterActivity() {
    private companion object {
        const val IMAGE_PICK_REQUEST = 4201
        const val MAX_IMAGE_BYTES = 10L * 1024L * 1024L
        val SUPPORTED_IMAGE_TYPES = setOf("image/png", "image/gif", "image/jpeg")
    }

    private var shareChannel: MethodChannel? = null
    private var pendingShare: Map<String, Any>? = null
    private var imagePickerResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        configureExternalUrlChannel(flutterEngine)
        configureShareChannel(flutterEngine)
        configureImageChannel(flutterEngine)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != IMAGE_PICK_REQUEST) {
            return
        }

        val result = imagePickerResult
        imagePickerResult = null
        if (result == null) {
            return
        }
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            result.success(null)
            return
        }

        try {
            result.success(copyImageToPrivateCache(uri))
        } catch (error: Exception) {
            result.error("image_copy_failed", error.message, null)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val sharedContent = sharedContentFrom(intent) ?: return
        val channel = shareChannel
        if (channel == null) {
            pendingShare = sharedContent
        } else {
            channel.invokeMethod("shared", sharedContent)
        }
    }

    private fun configureExternalUrlChannel(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "developer_wiki/external_url"
        ).setMethodCallHandler { call, result ->
            if (call.method != "open") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            val url = call.argument<String>("url")
            if (url.isNullOrBlank()) {
                result.error("invalid_url", "URL fehlt.", null)
                return@setMethodCallHandler
            }

            try {
                startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
                result.success(null)
            } catch (error: Exception) {
                result.error("open_failed", error.message, null)
            }
        }
    }

    private fun configureShareChannel(flutterEngine: FlutterEngine) {
        shareChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "developer_wiki/share"
        ).also { channel ->
            channel.setMethodCallHandler { call, result ->
                if (call.method != "getInitialShare") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }

                val content = pendingShare ?: sharedContentFrom(intent)
                pendingShare = null
                result.success(content)
            }
        }
    }

    private fun configureImageChannel(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "developer_wiki/image"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "pickImage" -> openImagePicker(result)
                "discardImage" -> {
                    val path = call.argument<String>("path")
                    if (path.isNullOrBlank()) {
                        result.error("invalid_path", "Bildpfad fehlt.", null)
                        return@setMethodCallHandler
                    }
                    try {
                        discardCachedImage(path)
                        result.success(null)
                    } catch (error: Exception) {
                        result.error("discard_failed", error.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun openImagePicker(result: MethodChannel.Result) {
        if (imagePickerResult != null) {
            result.error("picker_busy", "Die Bildauswahl ist bereits geöffnet.", null)
            return
        }
        imagePickerResult = result
        val picker = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "image/*"
            putExtra(
                Intent.EXTRA_MIME_TYPES,
                arrayOf("image/png", "image/gif", "image/jpeg")
            )
        }
        try {
            startActivityForResult(picker, IMAGE_PICK_REQUEST)
        } catch (error: Exception) {
            imagePickerResult = null
            result.error("picker_failed", error.message, null)
        }
    }

    private fun copyImageToPrivateCache(uri: Uri): Map<String, Any> {
        val mimeType = contentResolver.getType(uri)?.lowercase()
            ?: throw IllegalArgumentException("Der Bildtyp konnte nicht ermittelt werden.")
        if (mimeType !in SUPPORTED_IMAGE_TYPES) {
            throw IllegalArgumentException("Unterstützt werden PNG-, GIF- und JPEG-Bilder.")
        }

        val displayName = displayName(uri)
        val safeName = displayName
            .replace(Regex("[^A-Za-z0-9._-]"), "_")
            .takeLast(100)
            .ifBlank { "image" }
        val directory = File(cacheDir, "image_sources").apply { mkdirs() }
        val target = File(directory, "${UUID.randomUUID()}-$safeName")
        var total = 0L

        try {
            contentResolver.openInputStream(uri).use { input ->
                requireNotNull(input) { "Das Bild konnte nicht geöffnet werden." }
                FileOutputStream(target).use { output ->
                    val buffer = ByteArray(DEFAULT_BUFFER_SIZE)
                    while (true) {
                        val read = input.read(buffer)
                        if (read < 0) {
                            break
                        }
                        total += read
                        if (total > MAX_IMAGE_BYTES) {
                            throw IllegalArgumentException(
                                "Das Bild darf höchstens 10 MiB groß sein."
                            )
                        }
                        output.write(buffer, 0, read)
                    }
                }
            }
        } catch (error: Exception) {
            target.delete()
            throw error
        }

        if (total == 0L) {
            target.delete()
            throw IllegalArgumentException("Die ausgewählte Bilddatei ist leer.")
        }
        return mapOf(
            "path" to target.absolutePath,
            "name" to displayName,
            "mimeType" to mimeType,
            "sizeBytes" to total
        )
    }

    private fun displayName(uri: Uri): String {
        contentResolver.query(
            uri,
            arrayOf(OpenableColumns.DISPLAY_NAME),
            null,
            null,
            null
        )?.use { cursor ->
            if (cursor.moveToFirst()) {
                val index = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                if (index >= 0) {
                    return cursor.getString(index) ?: "image"
                }
            }
        }
        return uri.lastPathSegment ?: "image"
    }

    private fun discardCachedImage(path: String) {
        val directory = File(cacheDir, "image_sources").canonicalFile
        val image = File(path).canonicalFile
        val allowedPrefix = directory.path + File.separator
        require(image.path.startsWith(allowedPrefix)) {
            "Nur temporäre Bilddateien der App dürfen entfernt werden."
        }
        if (image.exists() && !image.delete()) {
            throw IllegalStateException("Die temporäre Bilddatei konnte nicht entfernt werden.")
        }
    }

    private fun sharedContentFrom(sourceIntent: Intent?): Map<String, Any>? {
        if (sourceIntent?.action != Intent.ACTION_SEND) {
            return null
        }
        val mimeType = sourceIntent.type?.lowercase()
        if (mimeType in SUPPORTED_IMAGE_TYPES) {
            val uri = sharedImageUri(sourceIntent) ?: return mapOf(
                "kind" to "image_error",
                "text" to "Das geteilte Bild konnte nicht gelesen werden."
            )
            return try {
                copyImageToPrivateCache(uri) + ("kind" to "image")
            } catch (error: Exception) {
                mapOf(
                    "kind" to "image_error",
                    "text" to (error.message ?: "Das Bild konnte nicht übernommen werden.")
                )
            }
        }
        if (mimeType != "text/plain") {
            return null
        }
        val text = sourceIntent.getStringExtra(Intent.EXTRA_TEXT)?.trim().orEmpty()
        if (text.isEmpty()) {
            return null
        }

        val componentName = sourceIntent.component?.className.orEmpty()
        val kind = if (componentName.endsWith("ShareLinkActivity")) "link" else "text"
        return mapOf("kind" to kind, "text" to text)
    }

    @Suppress("DEPRECATION")
    private fun sharedImageUri(sourceIntent: Intent): Uri? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            sourceIntent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
        } else {
            sourceIntent.getParcelableExtra(Intent.EXTRA_STREAM)
        }
    }
}
