// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "C4",
    platforms: [.macOS(.v10_15), .iOS(.v9), .tvOS(.v9)],
    products: [
        .library(
            name: "C4",
            targets: ["C4-iOS", "C4-tvOS"]),
    ],
    targets: [
        .target(
            name: "C4",
            path: "C4"),
        .testTarget(
            name: "C4Tests-iOS",
            dependencies: ["C4"],
            path: "TovalaKitTests"),
    ]
)
