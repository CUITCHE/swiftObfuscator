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
        let name: String
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
            } catch {
                print(error)
                exit(2)
            }
        }
    }
}
