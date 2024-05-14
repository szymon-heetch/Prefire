// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Prefire",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Prefire",
            targets: ["Prefire"]
        ),
        .plugin(
            name: "PrefirePlaybookPlugin",
            targets: ["PrefirePlaybookPlugin"]
        ),
        .plugin(
            name: "PrefireTestsPlugin",
            targets: ["PrefireTestsPlugin"]
        ),
    ],
    dependencies: [
        .package(path: "./PrefireMacros")
    ],
    targets: [
        .target(
            name: "Prefire",
            dependencies: [
                "PrefireMacros"
            ]
        ),
        .plugin(
            name: "PrefirePlaybookPlugin",
            capability: .buildTool(),
            dependencies: [
                "PrefireBinary",
                "PrefireSourcery",
            ]
        ),
        .plugin(
            name: "PrefireTestsPlugin",
            capability: .buildTool(),
            dependencies: [
                "PrefireBinary",
                "PrefireSourcery",
            ]
        ),
        .binaryTarget(
            name: "PrefireBinary",
            path: "Binaries/PrefireBinary.artifactbundle"
        ),
        .binaryTarget(
            name: "PrefireSourcery",
            path: "PrefireExecutable/Binaries/PrefireSourcery.artifactbundle"
        )
    ]
)
