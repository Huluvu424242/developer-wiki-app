package de.huluvu.developer_wiki_source_capture

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
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
}
