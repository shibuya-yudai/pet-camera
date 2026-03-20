// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PCTracking",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .library(name: "PCTracking", targets: ["PCTracking"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PCTracking",
            path: "Sources/PCTracking",
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "PCTrackingTests",
            dependencies: ["PCTracking"],
            path: "Tests/PCTrackingTests"
        ),
    ]
)
