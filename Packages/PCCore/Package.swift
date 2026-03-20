// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PCCore",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .library(name: "PCCore", targets: ["PCCore"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PCCore",
            path: "Sources/PCCore",
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "PCCoreTests",
            dependencies: ["PCCore"],
            path: "Tests/PCCoreTests"
        ),
    ]
)
