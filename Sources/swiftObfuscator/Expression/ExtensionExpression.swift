//
//  ExtensionExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/3/2.
//

import SwiftSyntax
import Foundation

class ExtensionExpression: ClassExpression {
    override var obfuscating: String? {
        set { assert(false, "Should not set it in extension clause.") }
        get { return main?.obfuscating }
    }

    override var exprType: ExpressionType {
        if let main = main {
            return main.exprType
        } else {
            return .unknown
        }
    }

    var conformsProtocols: TypeInheritanceClauseSyntax? { return inheritanceClause }
    var main: Expression?

    init(accessLevel: ExpressionAccessLevel, name: String, inheritanceClause: TypeInheritanceClauseSyntax?, exprType: ExpressionType, main: Expression?) {
        self.main = main
        super.init(accessLevel: accessLevel, name: name, inheritanceClause: inheritanceClause, exprType: exprType)
    }

    override var description: String {
        let propertiesString = properties.map { "- " + $0.description }.joined(separator: "\n\t\t")
        let methodsString = methods.map { "- " + $0.description }.joined(separator: "\n\t\t")
        return """
        \(accessLevel) \(name) (extension \(exprType)) = {
            - property:
                \(propertiesString)
            - function:
                \(methodsString)
        }
        """
    }
}
