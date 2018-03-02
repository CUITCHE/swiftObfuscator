//
//  LibraryClassExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/3/2.
//

import Foundation

class LibraryClassExpression: Expression {
    let name: String
    var exprType: ExpressionType { return .class }
    /// Always nil
    var obfuscating: String? {
        get { return nil }
        set { /* do nothing */ }
    }

    init(name: String) {
        self.name = name
    }
}

extension LibraryClassExpression: Hashable {
    static func == (lhs: LibraryClassExpression, rhs: LibraryClassExpression) -> Bool {
        return lhs.name == rhs.name
    }

    var hashValue: Int { return name.hashValue }
}

let boolType: LibraryClassExpression = LibraryClassExpression(name: "Bool")
let doubleType: LibraryClassExpression = LibraryClassExpression(name: "Double")
let intType: LibraryClassExpression = LibraryClassExpression(name: "Int")
let stringType: LibraryClassExpression = LibraryClassExpression(name: "String")
let arrayType: LibraryClassExpression = LibraryClassExpression(name: "Array")
let dictionaryType: LibraryClassExpression = LibraryClassExpression(name: "Dictionary")

/// Store third-part library or system class type.
var libraryClazzs: Set<LibraryClassExpression> = [boolType, doubleType, intType, stringType, arrayType, dictionaryType]
