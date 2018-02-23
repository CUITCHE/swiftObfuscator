//
//  EnumExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/2/23.
//

import Foundation
import SwiftSyntax

class EnumExpression: Expression {
    let name: String

    init(name: String) {
        self.name = name
    }
}
