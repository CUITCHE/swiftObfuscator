//
//  ParseProtocol.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/2/24.
//

import Foundation
import SwiftSyntax

class ParserProtocol: SyntaxRewriter {
    var funcDecls = [FunctionExpression]()
    var variableDelcs = [PropertyExpression]()

    override func visit(_ node: VariableDeclSyntax) -> DeclSyntax {
        if let binding = node.bindings.first, let type = binding.typeAnnotation?.type.description {
            variableDelcs.append(PropertyExpression(name: binding.pattern.description, type: type))
        } else {
            print("Can not parse protocol variable: \(node)")
            exit(1)
        }
        return super.visit(node)
    }

    override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
        funcDecls.append(FunctionExpression(name: node.identifier.description, signature: node.signature))
        return super.visit(node)
    }
}
