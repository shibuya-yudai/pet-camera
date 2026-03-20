// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PCFeatures",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "PCFeatures", targets: ["PCFeatures"]),
    ],
    dependencies: [
        .package(path: "../PCCore"),
        .package(path: "../PCTracking"),
        .package(path: "../PCScene"),
    ],
    targets: [
        .target(
            name: "PCFeatures",
            dependencies: ["PCCore", "PCTracking", "PCScene"],
            path: "Sources/PCFeatures",
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "PCFeaturesTests",
            dependencies: ["PCFeatures"],
            path: "Tests/PCFeaturesTests"
        ),
    ]
)
