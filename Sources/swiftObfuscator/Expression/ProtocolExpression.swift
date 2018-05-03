//
//  ProtocolExpression.swift
//  swiftObfuscator
//
//  Created by hejunqiu on 2018/2/23.
//

import SwiftSyntax

class ProtocolExpression: Expression {
    let accessLevel: ExpressionAccessLevel
    let name: String
    var exprType: ExpressionType { return .protocol }
    var obfuscating: String?

    let inheritanceClause: TypeInheritanceClauseSyntax?

    init(accessLevel: ExpressionAccessLevel, name: String, inheritanceClause: TypeInheritanceClauseSyntax?) {
        self.accessLevel = accessLevel
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.inheritanceClause = inheritanceClause
    }

    var methods = [FunctionExpression]()
    var properties = [PropertyExpression]()
}

extension ProtocolExpression: CustomStringConvertible {
    var description: String {
        let propertiesString = properties.map { "- " + $0.description }.joined(separator: "\n\t\t")
        let methodsString = methods.map { "- " + $0.description }.joined(separator: "\n\t\t")
        return """
        \(accessLevel) protocol \(name) = {
            - property:
                \(propertiesString)
            - function:
                \(methodsString)
        }
        """
    }
}
