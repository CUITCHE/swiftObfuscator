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
    let accessLevel: ExpressionAccessLevel
    let name: String
    var exprType: ExpressionType { return .enum }
    var obfuscating: String?

    init(accessLevel: ExpressionAccessLevel, name: String) {
        self.accessLevel = accessLevel
        self.name = name
    }

    class ABC {
        //
    }
}

extension EnumExpression.ABC {
    func foo() {}
}
