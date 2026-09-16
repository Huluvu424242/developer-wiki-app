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
        const val DOCUMENT_PICK_REQUEST = 4202
        const val MAX_IMAGE_BYTES = 10L * 1024L * 1024L
        const val MAX_SHARED_DOCUMENT_BYTES = 10L * 1024L * 1024L
        val SUPPORTED_IMAGE_TYPES = setOf("image/png", "image/gif", "image/jpeg")
        val SUPPORTED_DOCUMENT_TYPES = setOf("application/pdf")
    }

    private var shareChannel: MethodChannel? = null
    private var pendingShare: Map<String, Any>? = null
    private var imagePickerResult: MethodChannel.Result? = null
    private var documentPickerResult: MethodChannel.Result? = null
    private var documentMimeTypes: Set<String> = emptySet()
    private var documentMaxBytes: Long = 0L

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        configureExternalUrlChannel(flutterEngine)
        configureAppInfoChannel(flutterEngine)
        configureShareChannel(flutterEngine)
        configureImageChannel(flutterEngine)
        configureDocumentChannel(flutterEngine)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            IMAGE_PICK_REQUEST -> finishImagePicker(resultCode, data)
            DOCUMENT_PICK_REQUEST -> finishDocumentPicker(resultCode, data)
        }
    }

    private fun finishImagePicker(resultCode: Int, data: Intent?) {
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

    private fun finishDocumentPicker(resultCode: Int, data: Intent?) {
        val result = documentPickerResult
        val mimeTypes = documentMimeTypes
        val maxBytes = documentMaxBytes
        documentPickerResult = null
        documentMimeTypes = emptySet()
        documentMaxBytes = 0L
        if (result == null) {
            return
        }
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            result.success(null)
            return
        }
        try {
            result.success(
                copyDocumentToPrivateCache(
                    uri = uri,
                    allowedMimeTypes = mimeTypes,
                    maxBytes = maxBytes
                )
            )
        } catch (error: Exception) {
            result.error("document_copy_failed", error.message, null)
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

    private fun configureAppInfoChannel(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "developer_wiki/app_info"
        ).setMethodCallHandler { call, result ->
            if (call.method != "getAppInfo") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            try {
                @Suppress("DEPRECATION")
                val packageInfo = packageManager.getPackageInfo(packageName, 0)
                val buildNumber = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    packageInfo.longVersionCode.toString()
                } else {
                    @Suppress("DEPRECATION")
                    packageInfo.versionCode.toString()
                }
                result.success(
                    mapOf(
                        "version" to packageInfo.versionName.orEmpty(),
                        "buildNumber" to buildNumber
                    )
                )
            } catch (error: Exception) {
                result.error("app_info_failed", error.message, null)
            }
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
                        discardCachedFile(path, "image_sources", "Bilddatei")
                        result.success(null)
                    } catch (error: Exception) {
                        result.error("discard_failed", error.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun configureDocumentChannel(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "developer_wiki/document"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "pickDocument" -> {
                    val mimeTypes = call.argument<List<String>>("mimeTypes")
                        ?.filter { it.isNotBlank() }
                        ?.toSet()
                        .orEmpty()
                    val maxBytes = call.argument<Number>("maxBytes")?.toLong() ?: 0L
                    if (mimeTypes.isEmpty() || maxBytes <= 0L) {
                        result.error(
                            "invalid_contract",
                            "Der Dokumentvertrag enthält keinen gültigen Dateityp oder Größenwert.",
                            null
                        )
                    } else {
                        openDocumentPicker(result, mimeTypes, maxBytes)
                    }
                }
                "discardDocument" -> {
                    val path = call.argument<String>("path")
                    if (path.isNullOrBlank()) {
                        result.error("invalid_path", "Dokumentpfad fehlt.", null)
                        return@setMethodCallHandler
                    }
                    try {
                        discardCachedFile(path, "document_sources", "Dokumentdatei")
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

    private fun openDocumentPicker(
        result: MethodChannel.Result,
        mimeTypes: Set<String>,
        maxBytes: Long
    ) {
        if (documentPickerResult != null) {
            result.error("picker_busy", "Die Dokumentauswahl ist bereits geöffnet.", null)
            return
        }
        documentPickerResult = result
        documentMimeTypes = mimeTypes
        documentMaxBytes = maxBytes
        val picker = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = if (mimeTypes.size == 1) mimeTypes.first() else "*/*"
            if (mimeTypes.size > 1) {
                putExtra(Intent.EXTRA_MIME_TYPES, mimeTypes.toTypedArray())
            }
        }
        try {
            startActivityForResult(picker, DOCUMENT_PICK_REQUEST)
        } catch (error: Exception) {
            documentPickerResult = null
            documentMimeTypes = emptySet()
            documentMaxBytes = 0L
            result.error("picker_failed", error.message, null)
        }
    }

    private fun copyImageToPrivateCache(uri: Uri): Map<String, Any> {
        val mimeType = contentResolver.getType(uri)?.lowercase()
            ?: throw IllegalArgumentException("Der Bildtyp konnte nicht ermittelt werden.")
        if (mimeType !in SUPPORTED_IMAGE_TYPES) {
            throw IllegalArgumentException("Unterstützt werden PNG-, GIF- und JPEG-Bilder.")
        }
        return copyToPrivateCache(
            uri = uri,
            mimeType = mimeType,
            directoryName = "image_sources",
            fallbackName = "image",
            maxBytes = MAX_IMAGE_BYTES,
            emptyMessage = "Die ausgewählte Bilddatei ist leer.",
            tooLargeMessage = "Das Bild darf höchstens 10 MiB groß sein."
        )
    }

    private fun copyDocumentToPrivateCache(
        uri: Uri,
        allowedMimeTypes: Set<String>,
        maxBytes: Long
    ): Map<String, Any> {
        val mimeType = contentResolver.getType(uri)?.lowercase()
            ?: throw IllegalArgumentException("Der Dokumenttyp konnte nicht ermittelt werden.")
        if (mimeType !in allowedMimeTypes) {
            throw IllegalArgumentException(
                "Der Dateityp $mimeType wird für diese Dokument-Quelle nicht unterstützt."
            )
        }
        return copyToPrivateCache(
            uri = uri,
            mimeType = mimeType,
            directoryName = "document_sources",
            fallbackName = "document",
            maxBytes = maxBytes,
            emptyMessage = "Die ausgewählte Dokumentdatei ist leer.",
            tooLargeMessage = "Die Dokumentdatei überschreitet das zulässige Größenlimit."
        )
    }

    private fun copyToPrivateCache(
        uri: Uri,
        mimeType: String,
        directoryName: String,
        fallbackName: String,
        maxBytes: Long,
        emptyMessage: String,
        tooLargeMessage: String
    ): Map<String, Any> {
        val displayName = displayName(uri, fallbackName)
        val safeName = displayName
            .replace(Regex("[^A-Za-z0-9._-]"), "_")
            .takeLast(100)
            .ifBlank { fallbackName }
        val directory = File(cacheDir, directoryName).apply { mkdirs() }
        val target = File(directory, "${UUID.randomUUID()}-$safeName")
        var total = 0L

        try {
            contentResolver.openInputStream(uri).use { input ->
                requireNotNull(input) { "Die Datei konnte nicht geöffnet werden." }
                FileOutputStream(target).use { output ->
                    val buffer = ByteArray(DEFAULT_BUFFER_SIZE)
                    while (true) {
                        val read = input.read(buffer)
                        if (read < 0) {
                            break
                        }
                        total += read
                        if (total > maxBytes) {
                            throw IllegalArgumentException(tooLargeMessage)
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
            throw IllegalArgumentException(emptyMessage)
        }
        return mapOf(
            "path" to target.absolutePath,
            "name" to displayName,
            "mimeType" to mimeType,
            "sizeBytes" to total
        )
    }

    private fun displayName(uri: Uri, fallback: String = "image"): String {
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
                    return cursor.getString(index) ?: fallback
                }
            }
        }
        return uri.lastPathSegment ?: fallback
    }

    private fun discardCachedFile(path: String, directoryName: String, label: String) {
        val directory = File(cacheDir, directoryName).canonicalFile
        val file = File(path).canonicalFile
        val allowedPrefix = directory.path + File.separator
        require(file.path.startsWith(allowedPrefix)) {
            "Nur temporäre $label der App dürfen entfernt werden."
        }
        if (file.exists() && !file.delete()) {
            throw IllegalStateException("Die temporäre $label konnte nicht entfernt werden.")
        }
    }

    private fun sharedContentFrom(sourceIntent: Intent?): Map<String, Any>? {
        if (sourceIntent?.action != Intent.ACTION_SEND) {
            return null
        }
        val mimeType = sourceIntent.type?.lowercase()
        if (mimeType in SUPPORTED_IMAGE_TYPES) {
            val uri = sharedStreamUri(sourceIntent) ?: return mapOf(
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
        if (mimeType in SUPPORTED_DOCUMENT_TYPES) {
            val uri = sharedStreamUri(sourceIntent) ?: return mapOf(
                "kind" to "document_error",
                "text" to "Das geteilte Dokument konnte nicht gelesen werden."
            )
            return try {
                copyDocumentToPrivateCache(
                    uri = uri,
                    allowedMimeTypes = SUPPORTED_DOCUMENT_TYPES,
                    maxBytes = MAX_SHARED_DOCUMENT_BYTES
                ) + ("kind" to "document")
            } catch (error: Exception) {
                mapOf(
                    "kind" to "document_error",
                    "text" to (error.message ?: "Das Dokument konnte nicht übernommen werden.")
                )
            }
        }
        if (mimeType != "text/plain") {
            val stream = sharedStreamUri(sourceIntent)
            return if (stream != null || !mimeType.isNullOrBlank()) {
                mapOf(
                    "kind" to "unsupported_file",
                    "text" to "Dateityp ${mimeType ?: "unbekannt"} wird nicht unterstützt."
                )
            } else {
                null
            }
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
    private fun sharedStreamUri(sourceIntent: Intent): Uri? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            sourceIntent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
        } else {
            sourceIntent.getParcelableExtra(Intent.EXTRA_STREAM)
        }
    }
}
