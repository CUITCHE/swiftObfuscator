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
    static var protocols  = [ProtocolExpression]()
    static var mainclazzs = [ClassExpression]()
    static var extensions = [ExtensionExpression]()
    static var topfunctions  = [FunctionExpression]()

    private struct NestedParsePlaceholder: Syntax { }
    let filepaths: [URL]

    struct SourceFile {
        let name: FileNameType
        let filepath: URL
        let clazzs: [String: ClassExpression]
        let extensions: [ClassExpression]
        let protocols: [ProtocolExpression]
        let topFunctions: [FunctionExpression]
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
                parsed.append(SourceFile(name: item.lastPathComponent, filepath: item, clazzs: P.clazzes, extensions: P.extensions, protocols: P.protocols, topFunctions: P.topFunctions))
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
