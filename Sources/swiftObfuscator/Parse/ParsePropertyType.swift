//
//  ParsePropertyType.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/2/26.
//

import Foundation
import SwiftSyntax

class ParsePropertyType: SyntaxVisitor {
    var type: String? { return _type }
    private var _type: String?
    var exprType: PropertyExpression.PropertyTypeExpr { return _exprType }
    private var _exprType: PropertyExpression.PropertyTypeExpr = .unknown {
        didSet {
            switch _exprType {
            case .unknown:
                _type = nil
            case .certain:
                Log("Unreachable place")
                exit(-1)
            case .literal(let v):
                _type = "\(v)"
            case .func(_):
                _type = nil
            }
        }
    }

    override func visit(_ node: FunctionCallExprSyntax) {
        if !node.description.hasPrefix("[") {
            _exprType = .func(node)
        }
        defer {
            if case .unknown = _exprType {
                _exprType = .func(node)
            }
        }
        return super.visit(node)
    }

    override func visit(_ node: BooleanLiteralExprSyntax) {
        if case .unknown = exprType {
            _exprType = .literal(.Bool)
        }
        return super.visit(node)
    }

    override func visit(_ node: IntegerLiteralExprSyntax) {
        if case .unknown = exprType {
            _exprType = .literal(.Int)
        }
        return super.visit(node)
    }

    override func visit(_ node: FloatLiteralExprSyntax) {
        if case .unknown = exprType {
            _exprType = .literal(.Double)
        }
        return super.visit(node)
    }

    override func visit(_ node: StringLiteralExprSyntax) {
        if case .unknown = exprType {
            _exprType = .literal(.String)
        }
        return super.visit(node)
    }

    override func visit(_ node: StringSegmentSyntax) {
        if case .unknown = exprType {
            _exprType = .literal(.String)
        }
        return super.visit(node)
    }

    override func visit(_ node: ArrayExprSyntax) {
        if case .unknown = exprType {
            _exprType = .literal(.Array)
        }
        return super.visit(node)
    }

    override func visit(_ node: DictionaryExprSyntax) {
        if case .unknown = exprType {
            _exprType = .literal(.Dictionary)
        }
        return super.visit(node)
    }
}
