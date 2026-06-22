// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PeopleInSpaceXtool",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        // An xtool project should contain exactly one library product,
        // representing the main app.
        .library(
            name: "PeopleInSpaceXtool",
            targets: ["PeopleInSpaceXtool"]
        ),
    ],
    targets: [
        .target(
            name: "PeopleInSpaceXtool",
            dependencies: ["PeopleInSpaceKit"]
        ),
        // The Kotlin shared module, assembled by Gradle and staged by xtool at
        // this stable path before each build (see xtool.yml). The framework's
        // Swift module is `common`, so sources `import common`.
        .binaryTarget(
            name: "PeopleInSpaceKit",
            path: "xtool/kotlin/PeopleInSpaceKit.xcframework"
        ),
    ]
)
