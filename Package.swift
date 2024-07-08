// swift-tools-version: 5.9
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
    ]
)
