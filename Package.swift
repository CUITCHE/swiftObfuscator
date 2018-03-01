// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swiftObfuscator",
    dependencies: [
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.11.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "swiftObfuscator",
            dependencies: ["SQLite"]),
    ]
)

// In Mac OS X, use /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/swift to build
