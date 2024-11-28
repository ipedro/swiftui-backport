// swift-tools-version: 5.9

import PackageDescription

let isSDK = Context.packageDirectory.contains("/checkouts/")

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
        .library(
            name: "SwiftUIBackport",
            targets: ["SwiftUIBackport"]
        ),
        .library(
            name: "SwiftUIBackport_Examples",
            targets: ["SwiftUIBackport_Examples"]
        )
    ],
    targets: [
        .target(
            name: "SwiftUIBackport",
            path: isSDK ? "." : "Development", 
            sources: isSDK ? ["SwiftUIBackport.swift"] : nil
        ),
        .target(
            name: "SwiftUIBackport_Examples",
            path: ".",
            sources: ["Examples.swift"]
        ),
    ]
)
