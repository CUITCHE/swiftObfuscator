# swiftObfuscator
A simple lexical obfuscator of Swift

See [Swift Syntax and Structured Editing Library](https://github.com/apple/swift/tree/master/lib/Syntax)

Development：Swift-Development-Snapshot-2018-02-28-a-osx

# How to build
- Install Swift-Development-Snapshot
- cd to root directory and use /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/swift build

The dependence library SQLite.swift has a bug, need modify its code:
<br>`@import Foundation;` => `#import <Foundation/Foundation.h>` in SQLite-Bridging.h 