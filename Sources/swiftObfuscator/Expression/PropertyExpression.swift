//
//  PropertyExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/1/30.
//

import SwiftSyntax

/// Express property: 'var name: type'
class PropertyExpression: Expression {
    let kind: TokenSyntax
    let name: String
    let type: String
    var exprType: ExpressionType { return .property }

    init(name: String, type: String, letOrVar: TokenSyntax) {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.type = type.trimmingCharacters(in: .whitespacesAndNewlines)
        self.kind = letOrVar
    }
}

extension PropertyExpression: CustomStringConvertible {
    var description: String {
        return "\(kind)\(name): \(type)"
    }
}
