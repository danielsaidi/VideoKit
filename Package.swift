// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "VideoKit",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
        .macOS(.v12),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "VideoKit",
            targets: ["VideoKit"]
        )
    ],
    targets: [
        .target(
            name: "VideoKit"
        ),
        .testTarget(
            name: "VideoKitTests",
            dependencies: ["VideoKit"]
        )
    ]
)
