// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "VideoKit",
    defaultLocalization: "en",
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
            name: "VideoKit",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "VideoKitTests",
            dependencies: ["VideoKit"]
        )
    ]
)
