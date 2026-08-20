package de.huluvu.developer_wiki_source_capture

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var shareChannel: MethodChannel? = null
    private var pendingShare: Map<String, String>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        configureExternalUrlChannel(flutterEngine)
        configureShareChannel(flutterEngine)
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

    private fun sharedContentFrom(sourceIntent: Intent?): Map<String, String>? {
        if (sourceIntent?.action != Intent.ACTION_SEND || sourceIntent.type != "text/plain") {
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
}
