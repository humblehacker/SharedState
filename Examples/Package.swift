// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Examples",
    platforms: [
        .macOS("14.1"), // _logChanges() is only available on macOS 14.1
    ],
    products: [
        .library(name: "DistributedUpdates", targets: ["DistributedUpdates"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "shared-state-beta"),
    ],
    targets: [
        .target(
            name: "DistributedUpdates",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(name: "DistributedUpdatesTests", dependencies: ["DistributedUpdates"]),
    ]
)
