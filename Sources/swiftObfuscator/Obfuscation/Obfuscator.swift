//
//  Obfuscator.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/2/24.
//

import Foundation
import SwiftSyntax

typealias FileNameType = String

struct Obfuscator {
    private struct NestedParsePlaceholder: Syntax { }
    let filepaths: [URL]

    struct SourceFile {
        let name: FileNameType
        let filepath: URL
        let sourceFileParsiton: SourceFileParse
    }
    var parsed: [SourceFile] = []

    init(filepaths: [URL]) {
        self.filepaths = filepaths
    }

    mutating func start() {
        for item in filepaths {
            do {
                let sourceFile = try NestedParsePlaceholder.parse(item)
                let P = SourceFileParse()
                _ = P.visit(sourceFile)
                parsed.append(SourceFile(name: item.lastPathComponent, filepath: item, sourceFileParsiton: P))
                let file = parsed.first!
                print("class: \(file.sourceFileParsiton.clazzes)\n")
                print("extension: \(file.sourceFileParsiton.extension)\n")
                print("protocol: \(file.sourceFileParsiton.protocols)\n")
            } catch {
                print(error)
                exit(2)
            }
        }
    }
}
