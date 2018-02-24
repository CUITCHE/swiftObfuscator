//
//  Renamer.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/1/30.
//
import SwiftSyntax

class Renamer: SyntaxRewriter {

    // MARK: - 成员访问(属性、方法)解析
    override func visit(_ node: MemberAccessExprSyntax) -> ExprSyntax {
        // 比如：delegate?.cropFrameCaptureView(self, didFinish: item)中的delegate?.cropFrameCaptureView,
        // 或者 size.width
//        if let arguments = node.declNameArguments {
//            print(node, arguments)
//        }
//        print(node)
        return super.visit(node)
    }

    // MARK: - 方法的调用，包含调用的对象和方法
    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        // delegate?.cropFrameCaptureView(self, didFinish: item)
        // calledExpression: delegate?.cropFrameCaptureView
        // argumentList: self, didFinish: item
        //        print("\(node.calledExpression), \(node.argumentList)")
//        print(node.calledExpression)
        return super.visit(node)
    }

    override func visit(_ node: FunctionCallArgumentSyntax) -> Syntax {
        return super.visit(node)
    }


    // MARK: - string合成语法解析
    override func visit(_ node: StringInterpolationExprSyntax) -> ExprSyntax {
        // "criticalWidth: \(criticalWidth)"
        //        print(node)
        return super.visit(node)
    }

    override func visit(_ node: StringSegmentSyntax) -> Syntax {
        // "criticalWidth: \(criticalWidth)" => "criticalWidth: "
        //        print(node)
        return super.visit(node)
    }

    override func visit(_ node: ExpressionStmtSyntax) -> StmtSyntax {
//        print(node)
        return super.visit(node)
    }

    override func visit(_ node: IdentifierPatternSyntax) -> PatternSyntax {
        print(node.parent)
        return super.visit(node)
    }
}


