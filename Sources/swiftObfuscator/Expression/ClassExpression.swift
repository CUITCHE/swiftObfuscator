//
//  ClassExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/1/30.
//

import Foundation
import SwiftSyntax

protocol Expression {
    var name: String { get }
}

class ClassExpression: Expression {

    let name: String
    let inheritanceClause: TypeInheritanceClauseSyntax?

    required init(name: String, inheritanceClause: TypeInheritanceClauseSyntax?) {
        self.name = name
        self.inheritanceClause = inheritanceClause
    }

    var methods = [FunctionExpression]()
    var properties = [PropertyExpression]()
}
