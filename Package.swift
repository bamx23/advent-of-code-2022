// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "advent-of-code-2022",
    products: [
        .executable(
            name: "Run",
            targets: ["Run"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", branch: "release/1.1"),
    ],
    targets: [
        .executableTarget(
            name: "Run",
            dependencies: [
                "Days",
                "Shared",
                "Input",
            ]
        ),
        .testTarget(
            name: "Tests",
            dependencies: [
                "Days",
                "Shared",
                "Input",
            ]
        ),
        .target(
            name: "Input",
            dependencies: [
                "Shared",
            ],
            resources: [
                .copy("files"),
            ]
        ),
        .target(
            name: "Days",
            dependencies: [
                "Shared",
                .product(name: "Collections", package: "swift-collections"),
            ]
        ),
        .target(name: "Shared"),
    ]
)
