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
            if let modifiers = node.modifiers {
                for item in modifiers {
                    if let access = ExpressionAccessLevel(rawValue: item.description.trimmingCharacters(in: .whitespacesAndNewlines)) {
                        variableDelcs.append(PropertyExpression(accessLevel: access, name: binding.pattern.description, type: type))
                        return super.visit(node)
                    }
                }
            }
            variableDelcs.append(PropertyExpression(accessLevel: .internal, name: binding.pattern.description, type: type))
        } else {
            print("Can not parse protocol variable: \(node)")
            exit(1)
        }
        return super.visit(node)
    }

    override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
        if let modifiers = node.modifiers {
            for item in modifiers {
                if let access = ExpressionAccessLevel(rawValue: item.description.trimmingCharacters(in: .whitespacesAndNewlines)) {
                    funcDecls.append(FunctionExpression(accessLevel: access, name: node.identifier.description, signature: node.signature))
                    return super.visit(node)
                }
            }
        }
        funcDecls.append(FunctionExpression(accessLevel: .internal, name: node.identifier.description, signature: node.signature))
        return super.visit(node)
    }
}
