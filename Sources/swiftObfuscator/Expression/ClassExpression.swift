//
//  ClassExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/1/30.
//

import Foundation
import SwiftSyntax

class ClassExpression: Expression, CustomStringConvertible {
    let accessLevel: ExpressionAccessLevel
    let name: String
    var exprType: ExpressionType { return _exprType }
    private let _exprType: ExpressionType
    var obfuscating: String?

    let inheritanceClause: TypeInheritanceClauseSyntax?
    var innested: Expression? = nil

    var fullClassname: String {
        var names: [String] = [name]
        var nested: Expression? = innested
        while let expr = nested as? ClassExpression {
            names.append(expr.name)
            nested = expr.innested
        }
        names.reverse()
        return names.joined(separator: ".")
    }

    init(accessLevel: ExpressionAccessLevel, name: String, inheritanceClause: TypeInheritanceClauseSyntax?, exprType: ExpressionType) {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.inheritanceClause = inheritanceClause
        self.accessLevel = accessLevel
        self._exprType = exprType
    }

    var properties = [PropertyExpression]()
    var methods = [FunctionExpression]()

    var description: String {
        let propertiesString = properties.map { "- " + $0.description }.joined(separator: "\n\t\t")
        let methodsString = methods.map { "- " + $0.description }.joined(separator: "\n\t\t")
        return """
        \(accessLevel) \(exprType) \(fullClassname) = {
            - property:
                \(propertiesString)
            - function:
                \(methodsString)
        }
        """
    }
}
