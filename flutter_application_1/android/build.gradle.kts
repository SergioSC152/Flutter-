// Top-level build file where you can add configuration options common to all sub-projects/modules.

plugins {
    id("com.android.application") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
    id("com.google.gms.google-services") version "4.3.15" apply false
    id("dev.flutter.flutter-gradle-plugin") apply false
}

buildscript {
    dependencies {
        // Plugin de servicios de Google necesario para Firebase
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Estas líneas gestionan el build directory personalizado de Flutter
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Limpieza de build
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
