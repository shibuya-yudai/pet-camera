// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PCScene",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "PCScene", targets: ["PCScene"]),
    ],
    dependencies: [
        .package(path: "../PCCore"),
        .package(path: "../PCTracking"),
    ],
    targets: [
        .target(
            name: "PCScene",
            dependencies: ["PCCore", "PCTracking"],
            path: "Sources/PCScene",
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "PCSceneTests",
            dependencies: ["PCScene"],
            path: "Tests/PCSceneTests"
        ),
    ]
)
