//
//  EnumExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/2/23.
//

import Foundation
import SwiftSyntax

// TODO: 目前不能很好直接识别enumeration的声明

class EnumExpression: Expression {
    let name: String
    var exprType: ExpressionType { return .enum }

    init(name: String) {
        self.name = name
    }
}
