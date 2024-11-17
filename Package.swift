// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let isDevelopment = !Context.packageDirectory.contains("/checkouts/")

let package = Package(
    name: "swiftui-subviews-backport",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "swiftui-subviews-backport",
            targets: ["SubviewsBackport"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SubviewsBackport",
            path: isDevelopment ? "Development" : ".",
            sources: isDevelopment ? nil : ["SubviewsBackport.swift"]
        ),
    ]
)
