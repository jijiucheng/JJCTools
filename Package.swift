// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JJCTools",
    products: [
        .library(name: "JJCTools", targets: ["Kingfisher"])
    ],
    targets: [
        .target(name: "JJCTools", path: "Sources")
    ]
)
