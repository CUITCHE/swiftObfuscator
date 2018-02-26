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

    override func visit(_ node: PatternBindingSyntax) -> Syntax {
        guard let clazz = currentClazz else { return super.visit(node) }
        if clazz.clazzClauseCounter > clazz.functionClauseCounter {
            if let type = node.typeAnnotation?.type.description {
                clazz.clazz.properties.append(PropertyExpression(name: node.pattern.description, type: type, syntaxExpr: .certain))
            } else {
                let function = SyntaxFactory.makeFunctionDecl(attributes: nil, modifiers: nil, funcKeyword: SyntaxFactory.makeFuncKeyword(), identifier: SyntaxFactory.makeIdentifier("tempFunction"), genericParameterClause: nil, signature: SyntaxFactory.makeFunctionSignature(input: SyntaxFactory.makeBlankParameterClause(), throwsOrRethrowsKeyword: nil, output: nil), genericWhereClause: nil, body: SyntaxFactory.makeCodeBlock(leftBrace: SyntaxFactory.makeLeftBraceToken(), statements: SyntaxFactory.makeCodeBlockItemList([SyntaxFactory.makeCodeBlockItem(item: node, semicolon: nil)]), rightBrace: SyntaxFactory.makeRightBraceToken()))
                let ppt = ParsePropertyType()
                _ = ppt.visit(function)

                if case .unknown = ppt.exprType {
                    print("Can not recognise type of member variable: \(node), \(ppt.exprType)")
                    exit(3)
                } else {
                    let property = PropertyExpression(name: node.pattern.description, type: ppt.type, syntaxExpr: ppt.exprType)
                    clazz.clazz.properties.append(property)
                }
            }
        }
        return super.visit(node)
    }

    override func visit(_ node: InitializerDeclSyntax) -> DeclSyntax {
        guard let clazz = currentClazz else { return super.visit(node) }
        clazz.functionClauseCounter += 1
        defer {
            clazz.functionClauseCounter -= 1
        }
        return super.visit(node)
    }

    override func visit(_ node: InitializerClauseSyntax) -> Syntax {
        guard let clazz = currentClazz else { return super.visit(node) }
        clazz.functionClauseCounter += 1
        defer {
            clazz.functionClauseCounter -= 1
        }
        return super.visit(node)
    }
}
