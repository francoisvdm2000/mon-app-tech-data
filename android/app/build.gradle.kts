import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Lit android/key.properties (rootProject = dossier android)
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.mon_app_tech"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.mon_app_tech"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ✅ Signature release
    signingConfigs {
    create("release") {
        val keyAliasProp = keystoreProperties.getProperty("keyAlias")
            ?: error("Missing 'keyAlias' in android/key.properties")
        val keyPasswordProp = keystoreProperties.getProperty("keyPassword")
            ?: error("Missing 'keyPassword' in android/key.properties")
        val storeFileProp = keystoreProperties.getProperty("storeFile")
            ?: error("Missing 'storeFile' in android/key.properties")
        val storePasswordProp = keystoreProperties.getProperty("storePassword")
            ?: error("Missing 'storePassword' in android/key.properties")

        keyAlias = keyAliasProp
        keyPassword = keyPasswordProp
        storeFile = file(storeFileProp)
        storePassword = storePasswordProp
    }
}


    buildTypes {
        release {
            // ✅ On signe maintenant avec la config release (et plus debug)
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
