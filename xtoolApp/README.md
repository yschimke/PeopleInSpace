# PeopleInSpace — xtool app

A SwiftPM-based iOS front-end for PeopleInSpace, buildable with
[xtool](https://github.com/xtool-org/xtool) instead of Xcode. It consumes the
same shared Kotlin Multiplatform `:common` module as the Xcode app
(`PeopleInSpaceSwiftUI/`), but with no `.xcodeproj` — `xtool dev` drives the
whole build: Gradle assembles the shared XCFramework, xtool stages, embeds, and
signs it, then builds and installs the SwiftUI app.

This exists to **validate xtool's Kotlin Multiplatform support against a real
KMP project** (real `multiplatform-swiftpackage` + SKIE setup), as opposed to a
synthetic fixture.

## Layout

```
xtoolApp/
  xtool.yml        # bundleID + kotlin{} block driving the Gradle build
  Package.swift    # app target + PeopleInSpaceKit binaryTarget (the XCFramework)
  Sources/PeopleInSpaceXtool/
    PeopleInSpaceXtoolApp.swift   # @main; KoinKt.doInitKoin()
    ContentView.swift             # uses PersonListViewModel + SKIE Observing/onEnum
```

The Gradle root is the repo root (one level up), so `xtool.yml` sets
`projectDir: ..` and `module: common`.

## How the wiring works

1. `common/build.gradle.kts` registers `XCFramework("PeopleInSpaceKit")` over the
   iOS targets (dynamic framework, module name `common`).
2. xtool's default task derivation maps `framework: PeopleInSpaceKit` →
   `:common:assemblePeopleInSpaceKitDebugXCFramework`, with output at
   `common/build/XCFrameworks/debug/PeopleInSpaceKit.xcframework`.
3. xtool stages that to `xtoolApp/xtool/kotlin/PeopleInSpaceKit.xcframework`
   (the `binaryTarget` path), then embeds + ad-hoc signs it into the app.

## Build

```bash
cd xtoolApp
xtool setup      # one-time, configures the Darwin Swift SDK + signing
xtool dev        # assembles the KMP framework, builds + installs the app
```

## Validation status

| Step | Status |
|------|--------|
| `XCFramework("PeopleInSpaceKit")` registered; Gradle exposes `assemblePeopleInSpaceKit{Debug,Release}XCFramework` | ✅ verified on Linux |
| Task name + output path match xtool's `KotlinBuildPlan` derivation | ✅ verified on Linux |
| Off-Mac the iOS link tasks skip → `BUILD SUCCESSFUL`, no artifact → xtool reports its actionable error | ✅ verified on Linux |
| Kotlin/Native actually compiles the iOS framework | ⛔ **requires macOS** |
| `xtool dev` cross-builds the SwiftUI app and extracts the right XCFramework slice | ⛔ **requires macOS + Swift Darwin SDK** |

> Building the iOS XCFramework requires macOS — on Linux/Windows the Kotlin/Native
> iOS targets are silently skipped. The end-to-end `xtool dev` run must be verified
> on a Mac.
>
> Note: on Linux the project's `:common` build needs `--no-configuration-cache`
> (the multiplatform-swiftpackage plugin's `FatFrameworkTask` is not config-cache
> safe); this does not affect the `assemblePeopleInSpaceKit…XCFramework` path used
> by xtool.
