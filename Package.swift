// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let isDevelopment = !Context.packageDirectory.contains("/checkouts/")

var package = Package(
    name: "swiftui-backport",
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
            name: "SwiftUIBackport",
            targets: ["SwiftUIBackport"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftUIBackport",
            path: isDevelopment ? "Development" : ".",
            sources: isDevelopment ? nil : ["SwiftUIBackport.swift"]
        ),
        .target(
            name: "SwiftUIBackport_Examples",
            path: ".",
            sources: ["Examples.swift"]
        ),
    ]
)

if isDevelopment {
    package.products.append(
        .library(
            name: "SwiftUIBackport_Examples",
            targets: ["SwiftUIBackport_Examples"]
        )
    )
}
