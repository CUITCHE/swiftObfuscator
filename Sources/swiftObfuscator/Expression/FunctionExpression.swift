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
    var obfuscating: String?

    let signature: FunctionSignatureSyntax

    required init(name: String, signature: FunctionSignatureSyntax) {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.signature = signature
    }

    var parameterList: ParameterList?
    func parseSignature() {
        guard parameterList == nil else { return }
        var pl = ParameterList()
        for item in signature.input.parameterList {
            var argument = ParameterList.Parameter
        }
    }
}

extension FunctionExpression: CustomStringConvertible {
    var description: String {
        return "\(name)\(signature)"
    }
}

struct ParameterList {
    struct Parameter {
        let firstName: String
        var firstObfuscating: String? = nil

        let secondName: String?
        var secondObfuscating: String? = nil
        let type: Expression
    }
    var argument = [Parameter]()

    func makeIterator() -> Array<Parameter>.Iterator {
        return argument.makeIterator()
    }
}
