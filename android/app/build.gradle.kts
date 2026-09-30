import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// 正式签名：key.properties 由 CI（或本地发布流程）生成，**不入库**（.gitignore 已忽略）。
// 没有它时退回 debug 签名——能装，但换台机器就发不出可覆盖安装的更新
//（Android 要求同包名同签名），所以只适合内测。
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "com.quiz.mianyang_quiz"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.quiz.mianyang_quiz"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // **26 是 sentry_flutter 抬上来的下限，不是随便定的。**
        // Flutter 的默认值是 24，而 sentry_flutter 10.x 的 AAR 声明了 minSdk 26，
        // manifest 合并会直接失败：
        //     uses-sdk:minSdkVersion 24 cannot be smaller than version 26
        //        declared in library [:sentry_flutter]
        // 它给的另一条出路 `tools:overrideLibrary` **不要走**——那是强行合并，
        // 官方注释自己就写着"may lead to runtime failures"：库确实可能调用了
        // 24 上没有的 API。抬下限才是对的。
        //
        // 代价：不再支持 Android 7.x 及以下（API 26 = Android 8.0，2017 年）。
        minSdk = maxOf(flutter.minSdkVersion, 26)
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // key.properties 里有 storeFile=release.keystore（CI 把 keystore 写在 app/ 下）
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                // 没配正式签名时用它，`flutter run --release` 与本地验证照常能跑
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
