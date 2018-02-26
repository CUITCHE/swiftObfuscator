//
//  Lock.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/2/26.
//

import Foundation

enum lock {
    final class `guard` {
        unowned let mutex: NSLock
        init(_ mutex: NSLock) {
            self.mutex = mutex
            mutex.lock()
        }

        deinit {
            mutex.unlock()
        }
    }
}
