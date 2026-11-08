// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "MiniDigraph",
    products: [
        .library(
            name: "MiniDigraph",
            targets: ["MiniDigraph"]
        ),
    ],
    targets: [
        .target(
            name: "MiniDigraph"
        ),
        .testTarget(
            name: "MiniDigraphTests",
            dependencies: ["MiniDigraph"]
        ),
    ],
    swiftLanguageModes: [
        .v6,
    ]
)
