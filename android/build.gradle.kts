buildscript {
    dependencies {
        // AGP 9.0.1 bundles KGP 2.2.10, while Flutter 3.47.4 requires >= 2.2.20.
        // Keep built-in Kotlin enabled and raise its runtime KGP dependency explicitly.
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.2.20")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory.value(
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
)

subprojects {
    project.layout.buildDirectory.value(
        rootProject.layout.buildDirectory
            .dir(project.name)
            .get()
    )
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
