//
//  Lock.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/2/26.
//

import Foundation

extension NSLocking {
    func lock<R>(_ codeblock: @autoclosure () -> R) -> R {
        lock()
        defer {
            unlock()
        }
        return codeblock()
    }
}
