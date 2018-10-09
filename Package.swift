// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swiftObfuscator",
    dependencies: [
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.11.4"),
        .package(url: "https://github.com/apple/swift-syntax.git", .branch("0.40200.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "swiftObfuscator",
            dependencies: ["SQLite", "SwiftSyntax"]),
    ]
)

// In Mac OS X, use /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/swift build ❌
// use swift build 
