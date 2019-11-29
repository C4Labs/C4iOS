// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "C4",
    platforms: [.macOS(.v10_15), .iOS(.v9), .tvOS(.v9)],
    products: [
        .library(
            name: "C4",
            targets: ["C4-iOS"]),
    ],
    targets: [
        .target(
            name: "C4-iOS",
            path: "C4"),
        .testTarget(
            name: "C4Tests-iOS",
            dependencies: ["C4-iOS"],
            path: "Tests"),
    ]
)
