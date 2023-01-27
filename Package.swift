// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Modify",
    products: [
        .library(
            name: "Modify",
            targets: ["Modify"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Modify",
            dependencies: []
        ),
        .testTarget(
            name: "ModifyTests",
            dependencies: ["Modify"]
        ),
    ]
)
