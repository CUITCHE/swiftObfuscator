//
//  ParsePropertyType.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/2/26.
//

import Foundation
import SwiftSyntax

class ParsePropertyType: SyntaxRewriter {
    var type: String? { return _type }
    private var _type: String?
    var exprType: PropertyExpression.PropertyTypeExpr { return _exprType }
    private var _exprType: PropertyExpression.PropertyTypeExpr = .unknown {
        didSet {
            switch _exprType {
            case .unknown:
                _type = nil
            case .certain:
                print("Unreachable place")
                exit(-1)
            case .literal(let v):
                _type = "\(v)"
            case .func(_):
                _type = nil
            }
        }
    }

    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        if case .unknown = _exprType {
            let expr = node.description
            if expr.hasPrefix("[") { // maybe [] or [:]
                if expr.contains(":") {
                    var colon = 1, rightBrackets = 0, leftBrackets = 0
                    let colonFisrtIndex = expr.index(of: ":")!
                    for ch in expr[expr.index(after: colonFisrtIndex)...] {
                        if ch == "[" {
                            leftBrackets += 1
                        } else if ch == "]" {
                            rightBrackets += 1
                        }
                    }
                    rightBrackets -= leftBrackets
                    if colon == rightBrackets {
                        _exprType = .literal(.Dictionary)
                    } else {
                        _exprType = .literal(.Array)
                    }
                } else {
                    _exprType = .literal(.Array)
                }
            } else {
                _exprType = .func(node)
            }
        }
        return super.visit(node)
    }

    override func visit(_ node: BooleanLiteralExprSyntax) -> ExprSyntax {
        if case .unknown = exprType {
            _exprType = .literal(.Bool)
        }
        return super.visit(node)
    }

    override func visit(_ node: IntegerLiteralExprSyntax) -> ExprSyntax {
        if case .unknown = exprType {
            _exprType = .literal(.Int)
        }
        return super.visit(node)
    }

    override func visit(_ node: FloatLiteralExprSyntax) -> ExprSyntax {
        if case .unknown = exprType {
            _exprType = .literal(.Double)
        }
        return super.visit(node)
    }

    override func visit(_ node: StringLiteralExprSyntax) -> ExprSyntax {
        if case .unknown = exprType {
            _exprType = .literal(.String)
        }
        return super.visit(node)
    }

    override func visit(_ node: StringSegmentSyntax) -> Syntax {
        if case .unknown = exprType {
            _exprType = .literal(.String)
        }
        return super.visit(node)
    }

    override func visit(_ node: ArrayExprSyntax) -> ExprSyntax {
        if case .unknown = exprType {
            _exprType = .literal(.Array)
        }
        return super.visit(node)
    }

    override func visit(_ node: DictionaryExprSyntax) -> ExprSyntax {
        if case .unknown = exprType {
            _exprType = .literal(.Dictionary)
        }
        return super.visit(node)
    }
}
