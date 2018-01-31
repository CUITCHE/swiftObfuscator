//
//  PropertyExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/1/30.
//

import Foundation

class PropertyExpression: Expression {
    let name: String

    var hashValue: Int { return name.hashValue }

    static func == (lhs: PropertyExpression, rhs: PropertyExpression) -> Bool {
        return lhs.name == rhs.name
    }

    required init(name: String) {
        self.name = name
    }
}
