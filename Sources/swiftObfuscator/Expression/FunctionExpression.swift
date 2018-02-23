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
    let signature: FunctionSignatureSyntax

//    var hashValue: Int { return name.hashValue }
//
//    static func == (lhs: FunctionExpression, rhs: FunctionExpression) -> Bool {
//        return lhs.name == rhs.name
//    }

    required init(name: String, signature: FunctionSignatureSyntax) {
        self.name = name
        self.signature = signature
    }


}
