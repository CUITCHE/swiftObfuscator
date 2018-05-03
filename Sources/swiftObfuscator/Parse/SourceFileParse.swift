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
    var clazzes = [ClassExpression]()
    /// Include Custom and library
    var extensions = [String: Expression]()
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

    var protocols = [ProtocolExpression]()
    var topFunctions = [FunctionExpression]()

    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        var accessLevel: ExpressionAccessLevel = .internal
        if let modifier = node.accessLevelModifier {
            if let access = ExpressionAccessLevel(rawValue: modifier.name.description.trimmingCharacters(in: .whitespacesAndNewlines)) {
                accessLevel = access
            }
        }
        let newClazz = _NestingClazzClause(clazz: ClassExpression(accessLevel: accessLevel, name: node.identifier.description,
                                                                  inheritanceClause: node.inheritanceClause))
        if let lastone = currentClazz {
            newClazz.clazz.innested = lastone.clazz
        }

        _nestingClazzClauseList.append(newClazz)
        clazzes.append(newClazz.clazz)
        newClazz.clazzClauseCounter += 1

        defer {
            newClazz.clazzClauseCounter -= 1
            _nestingClazzClauseList.removeLast()
        }
        return super.visit(node)
    }

    override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        var accessLevel: ExpressionAccessLevel = .internal
        if let modifier = node.accessLevelModifier {
            if let access = ExpressionAccessLevel(rawValue: modifier.name.description.trimmingCharacters(in: .whitespacesAndNewlines)) {
                accessLevel = access
            }
        }
        let newClazz = _NestingClazzClause(clazz: ClassExpression(accessLevel: accessLevel, name: node.identifier.description,
                                                                  inheritanceClause: node.inheritanceClause))
        if let lastone = currentClazz {
            newClazz.clazz.innested = lastone.clazz
        }

        _nestingClazzClauseList.append(newClazz)
        clazzes.append(newClazz.clazz)
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

        var accessLevel: ExpressionAccessLevel = .internal
        if let modifier = node.accessLevelModifier {
            if let access = ExpressionAccessLevel(rawValue: modifier.name.description.trimmingCharacters(in: .whitespacesAndNewlines)) {
                accessLevel = access
            }
        }

        let protocolExpr = ProtocolExpression(accessLevel: accessLevel, name: node.identifier.description, inheritanceClause: node.inheritanceClause)
        protocolExpr.properties = pp.variableDelcs
        protocolExpr.methods    = pp.funcDecls
        protocols.append(protocolExpr)
        return super.visit(node)
    }

    override func visit(_ node: ExtensionDeclSyntax) -> DeclSyntax {
        var accessLevel: ExpressionAccessLevel = .internal
        if let modifier = node.accessLevelModifier {
            if let access = ExpressionAccessLevel(rawValue: modifier.name.description.trimmingCharacters(in: .whitespacesAndNewlines)) {
                accessLevel = access
            }
        }

        let newClazz = _NestingClazzClause(clazz: ClassExpression(accessLevel: accessLevel, name: node.extendedType.description,
                                                                  inheritanceClause: node.inheritanceClause))
        _nestingClazzClauseList.append(newClazz)
        self.extensions[newClazz.clazz.name] = newClazz.clazz
        newClazz.clazzClauseCounter += 1
        defer {
            newClazz.clazzClauseCounter -= 1
            _nestingClazzClauseList.removeLast()
        }
        return super.visit(node)
    }

    override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
        guard let clazz = currentClazz else {
            // FIXME:这里有可能是全局函数
            return super.visit(node)
        }
        var accessLevel: ExpressionAccessLevel = .internal
        if let modifiers = node.modifiers {
            for item in modifiers {
                if let access = ExpressionAccessLevel(rawValue: item.description.trimmingCharacters(in: .whitespacesAndNewlines)) {
                    accessLevel = access
                    break
                }
            }
        }
        clazz.clazz.methods.append(FunctionExpression(accessLevel: accessLevel, name: node.identifier.description, signature: node.signature))
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
                clazz.clazz.properties.append(PropertyExpression(accessLevel: .internal, name: node.pattern.description, type: type, syntaxExpr: .certain))
            } else {
                let function = SyntaxFactory.makeFunctionDecl(attributes: nil, modifiers: nil, funcKeyword: SyntaxFactory.makeFuncKeyword(), identifier: SyntaxFactory.makeIdentifier("tempFunction"), genericParameterClause: nil, signature: SyntaxFactory.makeFunctionSignature(input: SyntaxFactory.makeBlankParameterClause(), throwsOrRethrowsKeyword: nil, output: nil), genericWhereClause: nil, body: SyntaxFactory.makeCodeBlock(leftBrace: SyntaxFactory.makeLeftBraceToken(), statements: SyntaxFactory.makeCodeBlockItemList([SyntaxFactory.makeCodeBlockItem(item: node, semicolon: nil)]), rightBrace: SyntaxFactory.makeRightBraceToken()))
                let ppt = ParsePropertyType()
                _ = ppt.visit(function)

                if case .unknown = ppt.exprType {
                    print("Can not recognise type of member variable: \(node), \(ppt.exprType)")
                    exit(3)
                } else {
                    let property = PropertyExpression(accessLevel: .internal, name: node.pattern.description, type: ppt.type, syntaxExpr: ppt.exprType)
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
