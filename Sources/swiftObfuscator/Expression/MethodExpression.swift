//
//  MethodExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/1/30.
//

import Foundation

class MethodExpression: Expression {
    let name: String

    var hashValue: Int { return name.hashValue }

    static func == (lhs: MethodExpression, rhs: MethodExpression) -> Bool {
        return lhs.name == rhs.name
    }

    required init(name: String) {
        self.name = name
    }
}
