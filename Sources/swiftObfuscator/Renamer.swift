//
//  Renamer.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/1/30.
//
import SwiftSyntax

class Renamer: SyntaxRewriter {
    // MARK: - 方法定义、签名解析
    override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
//        print(node.signature, node.signature.input.leftParen, separator: "#")
//        for parameter in node.signature.input.parameterList {
//            print(parameter.typeAnnotation)
//        }
//        if node.identifier.text == "cropFrameCaptureView" {
//            return super.visit(node.withIdentifier(SyntaxFactory.makeIdentifier("cropFrameCaptureView_obfused")))
//        }
//        print(node.signature)
        return super.visit(node)
    }

    // MARK: - 成员访问(属性、方法)解析
    override func visit(_ node: MemberAccessExprSyntax) -> ExprSyntax {
        // 比如：delegate?.cropFrameCaptureView(self, didFinish: item)中的delegate?.cropFrameCaptureView,
        // 或者 size.width
//        if let arguments = node.declNameArguments {
//            print(node, arguments)
//        }
        return super.visit(node)
    }

    // MARK: - 方法的调用，包含调用的对象和方法
    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        // delegate?.cropFrameCaptureView(self, didFinish: item)
        // calledExpression: delegate?.cropFrameCaptureView
        // argumentList: self, didFinish: item
        //        print("\(node.calledExpression), \(node.argumentList)")
        return super.visit(node)
    }

    override func visit(_ node: FunctionCallArgumentSyntax) -> Syntax {
//        print(node)
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

    // MARK: - Class
    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
//        print(node.inheritanceClause)
        return super.visit(node)
    }
    // MARK - Struct
    override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
//        print(node)
        return super.visit(node)
    }

    override func visit(_ node: ProtocolDeclSyntax) -> DeclSyntax {
//        print(node)
        return super.visit(node)
    }

    override func visit(_ node: VariableDeclSyntax) -> DeclSyntax {
        print("----\(node)")
        for idx in node.bindings {
            print(idx.pattern, idx.typeAnnotation, idx.initializer, idx.accessor)
        }
        print("----End\n")
        return super.visit(node)
    }
}


