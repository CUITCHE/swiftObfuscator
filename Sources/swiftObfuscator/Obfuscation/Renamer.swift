//
//  Renamer.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/5/11.
//

import Foundation
import SwiftSyntax

class Renamer: SyntaxRewriter {
    /// class, struct, protocol, enum
    var fields: [Expression] = []
}
