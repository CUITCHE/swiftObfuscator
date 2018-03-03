//
//  LibraryClassExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/3/2.
//

import Foundation

class LibraryClassExpression: Expression {
    let accessLevel: ExpressionAccessLevel
    let name: String
    var exprType: ExpressionType { return .class }
    /// Always nil
    var obfuscating: String? {
        get { return nil }
        set { /* do nothing */ }
    }

    init(accessLevel: ExpressionAccessLevel, name: String) {
        self.accessLevel = accessLevel
        self.name = name
    }
}

extension LibraryClassExpression: Hashable {
    static func == (lhs: LibraryClassExpression, rhs: LibraryClassExpression) -> Bool {
        return lhs.name == rhs.name
    }

    var hashValue: Int { return name.hashValue }
}

let boolType: LibraryClassExpression = LibraryClassExpression(accessLevel: .public, name: "Bool")
let doubleType: LibraryClassExpression = LibraryClassExpression(accessLevel: .public, name: "Double")
let intType: LibraryClassExpression = LibraryClassExpression(accessLevel: .public, name: "Int")
let stringType: LibraryClassExpression = LibraryClassExpression(accessLevel: .public, name: "String")
let arrayType: LibraryClassExpression = LibraryClassExpression(accessLevel: .public, name: "Array")
let dictionaryType: LibraryClassExpression = LibraryClassExpression(accessLevel: .public, name: "Dictionary")

/// Store third-part library or system class type.
var libraryClazzs: Set<LibraryClassExpression> = [boolType, doubleType, intType, stringType, arrayType, dictionaryType]
