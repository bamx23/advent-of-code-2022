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
    targets: [
        .executableTarget(
            name: "Run",
            dependencies: [
                "Days",
                "Shared",
            ],
            resources: [
                .copy("Input"),
            ]
        ),
        .target(
            name: "Days",
            dependencies: [
                "Shared",
            ]
        ),
        .target(name: "Shared"),
    ]
)
