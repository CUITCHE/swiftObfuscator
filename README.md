# swiftObfuscator
A simple lexical obfuscator of Swift

See [SwiftSyntax](https://github.com/apple/swift-syntax)

Development：Xcode 10.0

The repo is developing.

# How to build
```shell
swift build
```

The dependence library SQLite.swift has a bug, need modify its code:
@import Foundation;` => `#import <Foundation/Foundation.h>` in SQLite-Bridging.h 