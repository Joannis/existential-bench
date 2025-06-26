// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bench",
    platforms: [
        .macOS("26")  
    ],
    dependencies: [
        .package(url: "https://github.com/google/swift-benchmark.git", from: "0.1.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "bench",
            dependencies: [
                .target(name: "Library"),
                .product(name: "Benchmark", package: "swift-benchmark"),
            ]),
        .target(name: "Library")
    ]
)
