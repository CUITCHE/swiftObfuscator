//
//  PropertyExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/1/30.
//

import SwiftSyntax

/// Express property: 'var name: type'
class PropertyExpression: Expression {
    enum PropertyTypeExpr {
        case unknown
        case certain

        enum Literal {
            case Bool, Double, Int, String, Array, Dictionary
        }
        case literal(Literal)

        case `func`(FunctionCallExprSyntax)
    }
    let name: String
    var type: String?
    var exprType: ExpressionType { return .property }
    var syntaxExpr: PropertyTypeExpr

    init(name: String, type: String?, syntaxExpr: PropertyTypeExpr = .unknown) {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.type = type?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.syntaxExpr = syntaxExpr
    }
}

extension PropertyExpression {
    var isCertain: Bool {
        switch syntaxExpr {
        case .literal(_): return true
        default: return false
        }
    }
}

extension PropertyExpression: CustomStringConvertible {
    var description: String {
        return "\(name): \(type ?? "Unknown")"
    }
}
