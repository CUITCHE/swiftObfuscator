//
//  Fetcher.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/2/23.
//

import SwiftSyntax
import Foundation

class Fetcher: SyntaxRewriter {
    var clazzes = [String: ClassExpression]()
    var `extension` = [String: ClassExpression]() // TODO: 可能是Swift自带库的扩展
    class _NestingClazzClause {
        let clazz: ClassExpression
        // 使用clazzClauseCounter、functionClauseCounter来识别成员变量的声明
        var clazzClauseCounter: Int = 0
        var functionClauseCounter: Int = 0
        init(clazz: ClassExpression) {
            self.clazz = clazz
        }
    }
    private var _nestingClazzClauseList = [_NestingClazzClause]()
    var currentClazz: _NestingClazzClause? { return _nestingClazzClauseList.last }

    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        _nestingClazzClauseList.append(_NestingClazzClause(clazz: ClassExpression(name: node.identifier.description,
                                                                                  inheritanceClause: node.inheritanceClause)))
        clazzes[node.identifier.description] = currentClazz!.clazz
        currentClazz!.clazzClauseCounter += 1
        defer {
            if _nestingClazzClauseList.isEmpty == false {
                _nestingClazzClauseList.removeLast()
            }
            currentClazz!.clazzClauseCounter -= 1
        }
        return super.visit(node)
    }

    override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        _nestingClazzClauseList.append(_NestingClazzClause(clazz: ClassExpression(name: node.identifier.description,
                                                                                  inheritanceClause: node.inheritanceClause)))
        clazzes[node.identifier.description] = currentClazz!.clazz
        currentClazz!.clazzClauseCounter += 1
        defer {
            if _nestingClazzClauseList.isEmpty == false {
                _nestingClazzClauseList.removeLast()
            }
            currentClazz!.clazzClauseCounter -= 1
        }
        return super.visit(node)
    }

    override func visit(_ node: ExtensionDeclSyntax) -> DeclSyntax {
        _nestingClazzClauseList.append(_NestingClazzClause(clazz: ClassExpression(name: node.extendedType.description,
                                                                                  inheritanceClause: node.inheritanceClause)))
        self.extension[node.extendedType.description] = currentClazz!.clazz
        currentClazz!.clazzClauseCounter += 1
        defer {
            if _nestingClazzClauseList.isEmpty == false {
                _nestingClazzClauseList.removeLast()
            }
            currentClazz!.clazzClauseCounter -= 1
        }
        return super.visit(node)
    }

    override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
        guard let clazz = currentClazz else { return super.visit(node) }
        clazz.clazz.methods.append(FunctionExpression(name: node.identifier.description, signature: node.signature))
        clazz.functionClauseCounter += 1
        defer {
            clazz.functionClauseCounter -= 1
        }
        return super.visit(node)
    }

    override func visit(_ node: VariableDeclSyntax) -> DeclSyntax {
        guard let clazz = currentClazz else { return super.visit(node) }
        if clazz.clazzClauseCounter > clazz.functionClauseCounter {
            if let binding = node.bindings.first {
                if let type = binding.typeAnnotation?.description {
                    clazz.clazz.properties.append(PropertyExpression(name: binding.pattern.description, type: type))
                } else {
                    print("'\(node)' hasn't specified type in class(\(clazz.clazz.name)). Please specify one")
                    exit(1)
                }
            }
        }
        return super.visit(node)
    }
}

extension Fetcher {
    class ABC {
        var a = 0
    }
}
