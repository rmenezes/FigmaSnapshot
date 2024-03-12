// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "figma-snapshot",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "FigmaSnapshot",
            targets: ["FigmaSnapshot"]
        ),
    ],
    targets: [
        .target(
            name: "FigmaSnapshot"
        ),
        .testTarget(
            name: "FigmaSnapshotTests",
            dependencies: ["FigmaSnapshot"]
        ),
    ]
)
