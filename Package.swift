// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "base64-swift",
    products: [
        .library(
            name: "Base64Swift",
            targets: ["Base64Swift"]),
    ],
    targets: [
        .target(
            name: "Base64Swift"
        )
    ]
)
