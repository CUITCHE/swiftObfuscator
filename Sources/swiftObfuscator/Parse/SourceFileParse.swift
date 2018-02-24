//
//  SourceFileParse.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/2/23.
//

import SwiftSyntax
import Foundation

/// 提取一个Swift文件的class(struct)、extension、protocol、function、member-variable。
/// 整理数据，为后续工作提供数据支撑。
class SourceFileParse: SyntaxRewriter {
    var clazzes = [String: ClassExpression]()
    var `extension` = [String: ClassExpression]() // TODO: 可能是Swift自带库的扩展
    private class _NestingClazzClause {
        let clazz: ClassExpression
        // 使用clazzClauseCounter、functionClauseCounter来识别成员变量的声明
        var clazzClauseCounter: Int = 0
        var functionClauseCounter: Int = 0
        init(clazz: ClassExpression) {
            self.clazz = clazz
        }
    }
    private var _nestingClazzClauseList = [_NestingClazzClause]()
    private var currentClazz: _NestingClazzClause? { return _nestingClazzClauseList.last }

    var protocols = [String: ProtocolExpression]()

    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        let newClazz = _NestingClazzClause(clazz: ClassExpression(name: node.identifier.description,
                                                                  inheritanceClause: node.inheritanceClause))
        if let lastone = currentClazz {
            newClazz.clazz.innested = newClazz.clazz
        }

        _nestingClazzClauseList.append(newClazz)
        clazzes[node.identifier.description] = newClazz.clazz
        newClazz.clazzClauseCounter += 1

        defer {
            newClazz.clazzClauseCounter -= 1
            _nestingClazzClauseList.removeLast()
        }
        return super.visit(node)
    }

    override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        let newClazz = _NestingClazzClause(clazz: ClassExpression(name: node.identifier.description,
                                                                  inheritanceClause: node.inheritanceClause))
        if let lastone = currentClazz {
            newClazz.clazz.innested = newClazz.clazz
        }

        _nestingClazzClauseList.append(newClazz)
        clazzes[node.identifier.description] = newClazz.clazz
        newClazz.clazzClauseCounter += 1

        defer {
            newClazz.clazzClauseCounter -= 1
            _nestingClazzClauseList.removeLast()
        }
        return super.visit(node)
    }

    override func visit(_ node: ProtocolDeclSyntax) -> DeclSyntax {
        let structDecl = SyntaxFactory.makeStructDecl(attributes: nil, accessLevelModifier: nil, structKeyword: SyntaxFactory.makeStructKeyword(), identifier: SyntaxFactory.makeIdentifier("Temp"), genericParameterClause: nil, inheritanceClause: nil, genericWhereClause: nil, members: node.members)
        let pp = ParserProtocol()
        _ = pp.visit(structDecl)

        let protocolExpr = ProtocolExpression(name: node.identifier.description, inheritanceClause: node.inheritanceClause)
        protocolExpr.properties = pp.variableDelcs
        protocolExpr.methods    = pp.funcDecls
        protocols[protocolExpr.name] = protocolExpr
        return super.visit(node)
    }

    override func visit(_ node: ExtensionDeclSyntax) -> DeclSyntax {
        let newClazz = _NestingClazzClause(clazz: ClassExpression(name: node.extendedType.description,
                                                                  inheritanceClause: node.inheritanceClause))
        _nestingClazzClauseList.append(newClazz)
        self.extension[node.extendedType.description] = newClazz.clazz
        newClazz.clazzClauseCounter += 1
        defer {
            newClazz.clazzClauseCounter -= 1
            _nestingClazzClauseList.removeLast()
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
                    clazz.clazz.properties.append(PropertyExpression(name: binding.pattern.description, type: type, letOrVar: node.letOrVarKeyword))
                } else {
                    if let component = binding.description.components(separatedBy: "=").last?.trimmingCharacters(in: .whitespacesAndNewlines) {
                        let type: String
                        if component == "false" || component == "true" {
                            type = "Bool"
                        } else if component.hasPrefix("0") || Double(component) != nil {
                            type = "Swift.Digital"
                        } else if component.hasPrefix("[") {
                            type = "Swift.Collection"
                        } else if component.hasPrefix("\"") {
                            type = "String"
                        } else {
                            let letfBraceIndex = component.index(of: "(") ?? component.endIndex
                            let dotIndex = component.index(of: ".") ?? component.endIndex
                            let perferredIndex = min(letfBraceIndex, dotIndex)
                            type = String(component[...component.index(before: perferredIndex)])
                            print("'\(node.description.trimmingCharacters(in: .whitespacesAndNewlines))' hasn't specified type in class(\(clazz.clazz.name)). We suppose it is \(type).")
                        }
                        clazz.clazz.properties.append(PropertyExpression(name: binding.pattern.description, type: type, letOrVar: node.letOrVarKeyword))
                    } else {
                        print("'\(node)' hasn't specified type in class(\(clazz.clazz.name)). Please specify one.")
                        exit(1)
                    }
                }
            }
        }
        return super.visit(node)
    }
}
