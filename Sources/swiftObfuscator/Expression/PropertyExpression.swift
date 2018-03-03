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

        var libraryClassType: LibraryClassExpression? {
            switch self {
            case .literal(let literal):
                switch literal {
                case .Bool: return boolType
                case .Double: return doubleType
                case .Int: return intType
                case .String: return stringType
                case .Array: return arrayType
                case .Dictionary: return dictionaryType
                }
            default:
                return nil
            }
        }
    }
    let accessLevel: ExpressionAccessLevel
    let name: String
    var obfuscating: String?
    var typeName: String?
    var type: Expression?
    var exprType: ExpressionType { return .property }

    var syntaxExpr: PropertyTypeExpr

    init(accessLevel: ExpressionAccessLevel, name: String, type: String?, syntaxExpr: PropertyTypeExpr = .unknown) {
        self.accessLevel = accessLevel
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.typeName = type?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.syntaxExpr = syntaxExpr
        self.type = syntaxExpr.libraryClassType
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
        return "\(name): \(typeName ?? "Unknown")"
    }
}
