//
//  ExtensionExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/3/2.
//

import SwiftSyntax

class ExtensionExpression: Expression {
    let accessLevel: ExpressionAccessLevel
    let name: String
    var obfuscating: String? {
        set { }
        get { return nil }
    }
    var exprType: ExpressionType { return .class }

    let conformsProtocols: TypeInheritanceClauseSyntax?
    var main: Expression?

    init(accessLevel: ExpressionAccessLevel, name: String, inheritanceClause: TypeInheritanceClauseSyntax?, main: Expression?) {
        self.accessLevel = accessLevel
        self.name = name
        self.conformsProtocols = inheritanceClause
        self.main = main
    }

    var properties = [PropertyExpression]()
    var methods = [FunctionExpression]()
}
