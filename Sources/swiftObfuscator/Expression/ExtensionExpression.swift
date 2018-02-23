//
//  ExtensionExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/2/23.
//

import SwiftSyntax

class ExtensionExpression: Expression {
    let name: String
    let main: ClassExpression
    let inheritanceClause: TypeInheritanceClauseSyntax?
    init(name: String, main: ClassExpression, inheritanceClause: TypeInheritanceClauseSyntax?) {
        self.name = name
        self.main = main
        self.inheritanceClause = inheritanceClause
    }
}
