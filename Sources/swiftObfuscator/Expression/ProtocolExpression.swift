//
//  ProtocolExpression.swift
//  swiftObfuscator
//
//  Created by hejunqiu on 2018/2/23.
//

import SwiftSyntax

class ProtocolExpression: Expression {
    let name: String
    var exprType: ExpressionType { return .protocol }
    var obfuscating: String?

    let inheritanceClause: TypeInheritanceClauseSyntax?

    init(name: String, inheritanceClause: TypeInheritanceClauseSyntax?) {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.inheritanceClause = inheritanceClause
    }

    var methods = [FunctionExpression]()
    var properties = [PropertyExpression]()
}

extension ProtocolExpression: CustomStringConvertible {
    var description: String {
        return "\(name)<\(properties), \(methods)>"
    }
}
