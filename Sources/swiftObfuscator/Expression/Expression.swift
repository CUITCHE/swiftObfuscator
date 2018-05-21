//
//  Expression.swift
//  swiftObfuscator
//
//  Created by hejunqiu on 2018/2/23.
//

import Foundation
import ObjectiveC

enum ExpressionType {
    case `class`, `struct`, `protocol`, `enum`
    case `func`, property
    /// 用于extension，不知道extension的是class还是struct的时候。当遍历完所有已知的class还不知道是谁，就可以断定是library了。
    case unknown
}

enum ExpressionAccessLevel: String {
    case `open`, `public`, `internal`, `fileprivate`, `private`
}

protocol Expression {
    var accessLevel: ExpressionAccessLevel { get }
    var name: String { get }

    var exprType: ExpressionType { get }

    /// The string of obfuscating name
    var obfuscating: String? { get set }
}

extension Expression {
    var isClass: Bool { return exprType == .class }
    var isStruct: Bool { return exprType == .struct }
    var isProtocol: Bool { return exprType == .protocol }
    var isEnum: Bool { return exprType == .enum }
    var isFunc: Bool { return exprType == .func }
    var isProperty: Bool { return exprType == .property }
}
