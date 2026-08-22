plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

fun releaseSigningValue(name: String): String? =
    (project.findProperty(name) as String?)
        ?.takeIf { it.isNotBlank() }
        ?: System.getenv(name)?.takeIf { it.isNotBlank() }

val hasReleaseSigningConfig = listOf(
    "ANDROID_KEYSTORE_PATH",
    "ANDROID_KEYSTORE_PASSWORD",
    "ANDROID_KEY_ALIAS",
    "ANDROID_KEY_PASSWORD",
).all { releaseSigningValue(it) != null }

android {
    namespace = "de.huluvu.developer_wiki_source_capture"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "de.huluvu.developer_wiki_source_capture"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "0.1.0"
    }

    signingConfigs {
        if (hasReleaseSigningConfig) {
            create("release") {
                storeFile = file(releaseSigningValue("ANDROID_KEYSTORE_PATH")!!)
                storePassword = releaseSigningValue("ANDROID_KEYSTORE_PASSWORD")
                keyAlias = releaseSigningValue("ANDROID_KEY_ALIAS")
                keyPassword = releaseSigningValue("ANDROID_KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName(
                if (hasReleaseSigningConfig) "release" else "debug",
            )
        }
    }
}

flutter {
    source = "../.."
}
