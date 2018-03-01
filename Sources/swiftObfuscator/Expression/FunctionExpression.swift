//
//  FunctionExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/1/30.
//

import Foundation
import SwiftSyntax

class FunctionExpression: Expression {
    let name: String
    var exprType: ExpressionType { return .func }

    let signature: FunctionSignatureSyntax

    required init(name: String, signature: FunctionSignatureSyntax) {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.signature = signature
    }
}

extension FunctionExpression: CustomStringConvertible {
    var description: String {
        return "\(name)\(signature)"
    }
}
