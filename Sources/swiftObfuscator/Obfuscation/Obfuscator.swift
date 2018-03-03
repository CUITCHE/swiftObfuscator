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
    static var extensions = [Expression]()
    static var topfunctions  = [FunctionExpression]()

    private struct NestedParsePlaceholder: Syntax { }
    let filepaths: [URL]

    struct SourceFile {
        let name: FileNameType
        let filepath: URL
        let clazzs: [ClassExpression]
        let extensions: [String: Expression]
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
                let sp = SourceFileParse()
                _ = sp.visit(sourceFile)
                parsed.append(SourceFile(name: item.lastPathComponent, filepath: item, clazzs: sp.clazzes, extensions: sp.extensions, protocols: sp.protocols, topFunctions: sp.topFunctions))
            } catch {
                print(error)
                exit(2)
            }
        }
        merge()
    }

    mutating func merge() {
        for item in parsed {
            Obfuscator.mainclazzs.append(contentsOf: item.clazzs)
        }
        Configure.shared.debug {
            let names = Obfuscator.mainclazzs.map({
                return $0.fullClassname
            }).sorted()
            for item in zip(names, names.dropFirst()) {
                if item.0 == item.1 {
                    print("The Same class name! => \(item)")
                }
            }
        }
    }
}
