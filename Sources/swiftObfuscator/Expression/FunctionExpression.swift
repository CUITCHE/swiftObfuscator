//
//  FunctionExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/1/30.
//

import Foundation
import SwiftSyntax

class FunctionExpression: Expression {
    let accessLevel: ExpressionAccessLevel
    let name: String
    var exprType: ExpressionType { return .func }
    var obfuscating: String?

    let signature: FunctionSignatureSyntax

    init(accessLevel: ExpressionAccessLevel, name: String, signature: FunctionSignatureSyntax) {
        self.accessLevel = accessLevel
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.signature = signature
    }

    var parameterList: ParameterList?
    /// 将参数整理，分离出name和type
    func prepareArguments() {
        guard parameterList == nil, parameterList != nil else { return }
        var pl = ParameterList()
        for item in signature.input.parameterList {
            let argument = ParameterList.Parameter(firstName: item.firstName.text, secondName: item.secondName?.text, typeString: item.typeAnnotation.description, type: nil, firstObfuscating: nil, secondObfuscating: nil)
            pl.append(argument)
        }
        parameterList = pl
    }
}

extension FunctionExpression: CustomStringConvertible {
    var description: String {
        return "\(name)\(signature)"
    }
}

extension FunctionExpression: Equatable {
    static func == (lhs: FunctionExpression, rhs: FunctionExpression) -> Bool {
        return lhs.name == rhs.name && lhs.signature == rhs.signature
    }
}

struct ParameterList {
    struct Parameter {
        let firstName: String
        let secondName: String?
        let typeString: String
        var type: Expression? = nil

        var firstObfuscating: String? = nil
        var secondObfuscating: String? = nil
    }

    private var argument = [Parameter]()

    func makeIterator() -> Array<Parameter>.Iterator {
        return argument.makeIterator()
    }

    mutating func append(_ newElement: Parameter) {
        argument.append(newElement)
    }
}
