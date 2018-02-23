//
//  PropertyExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/1/30.
//

import SwiftSyntax

class PropertyExpression: Expression {
    let name: String
    let type: String

    required init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}
