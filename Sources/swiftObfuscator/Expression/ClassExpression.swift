//
//  ClassExpression.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/1/30.
//

import Foundation

protocol Expression: Hashable {
    var name: String { get }
    init(name: String)
}

class ClassExpression: Expression {
    let name: String

    var hashValue: Int { return name.hashValue }

    static func == (lhs: ClassExpression, rhs: ClassExpression) -> Bool {
        return lhs.name == rhs.name
    }

    required init(name: String) {
        self.name = name
    }

    private var _methods = [MethodExpression]()
    var methods: [MethodExpression] { return _methods }

    private var _properties = [PropertyExpression]()
    var properties: [PropertyExpression] { return _properties }
}
