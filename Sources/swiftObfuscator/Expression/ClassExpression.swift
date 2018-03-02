//
//  ClassExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/1/30.
//

import Foundation
import SwiftSyntax

class ClassExpression: Expression {
    let name: String
    var exprType: ExpressionType { return .class }
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

    required init(name: String, inheritanceClause: TypeInheritanceClauseSyntax?) {
        self.name = name
        self.inheritanceClause = inheritanceClause
    }

    var properties = [PropertyExpression]()
    var methods = [FunctionExpression]()
}

extension ClassExpression: CustomStringConvertible {
    var description: String {
        return "\(fullClassname)<\(properties), \(methods)>"
    }
}
