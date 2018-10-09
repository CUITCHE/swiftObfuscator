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

    let parameterList: ParameterList
    let returnType: String
    var obfuscating: String?
    var parent: Expression?
    let isOverride: Bool
    let isObjc: Bool

    init(superAccessLevel accessLevel: ExpressionAccessLevel?, modifierList: ModifierListSyntax?, name: String, signature: FunctionSignatureSyntax, parent: Expression?) {
        var accessLevel: ExpressionAccessLevel = accessLevel ?? .internal
        var isObjc = false
        var isOverride = false
        if let modifiers = modifierList {
            for val in modifiers {
                if let modifier = (val as? DeclModifierSyntax)?.name.text {
                    if let val = ExpressionAccessLevel(rawValue: modifier) {
                        accessLevel = val
                    } else if modifier == "override" {
                        isOverride = true
                    }
                } else if let modifierList = val as? AttributeListSyntax {
                    for val in modifierList {
                        if val.attributeName.text == "objc" {
                            isObjc = true; break
                        }
                    }
                }
            }
        }
        self.parent = parent
        self.isObjc = isObjc
        self.isOverride = isOverride
        self.accessLevel = accessLevel
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        returnType = signature.output?.returnType.description.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Void"

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
        var declModifiers = [String]()
        isObjc ? declModifiers.append("@objc") : ()
        declModifiers.append("\(accessLevel)")
        isOverride ? declModifiers.append("override") : ()
        return "\(declModifiers.joined(separator: " ")) \(name)(\(parameterList)) -> \(returnType)"
    }
}

extension FunctionExpression: Equatable {
    static func == (lhs: FunctionExpression, rhs: FunctionExpression) -> Bool {
        return lhs.name == rhs.name && lhs.parameterList == rhs.parameterList && lhs.returnType == rhs.returnType
    }
}

struct ParameterList: Equatable, CustomStringConvertible {
    static func == (lhs: ParameterList, rhs: ParameterList) -> Bool {
        return lhs.argument == rhs.argument
    }
    struct Parameter: Equatable {
        static func == (lhs: ParameterList.Parameter, rhs: ParameterList.Parameter) -> Bool {
            return lhs.firstName == rhs.firstName && lhs.typeString == rhs.typeString &&
            lhs.secondName == rhs.secondName
        }

        let firstName: String // Maybe '_'
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

    var description: String {
        var desc = [String]()
        for val in self.makeIterator() {
            if let second = val.secondName {
                desc.append([val.firstName, "\(second):", val.typeString].joined(separator: " "))
            } else {
                desc.append(["\(val.firstName):", val.typeString].joined(separator: " "))
            }

        }
        return desc.joined(separator: ", ")
    }
}
