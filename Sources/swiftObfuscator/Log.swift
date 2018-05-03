//
//  Errors.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/5/3.
//

import Foundation

private struct DebugTextOutput: TextOutputStream {
    mutating func write(_ string: String) {
        fputs(string, stdout)
    }
}
private let dateFormatter: DateFormatter = {
    let fmt = DateFormatter()
    fmt.locale = Locale.current
    fmt.dateFormat = "yyyy-MM-dd HH:mm:ss.Z"
    return fmt
}()

private var output = DebugTextOutput()

private func formatDate(_ date: Date) -> String {
    let str = dateFormatter.string(from: date)
    return str.replacingOccurrences(of: ".", with: String(format: ".%06ld", Int64(date.timeIntervalSince1970 * 1000000) % 1000000))
}

/// 输出日志到控制台。
///
/// 例如在本行执行Log
///
///     Log(1234)
///     // Prints '2017-12-05 17:10:41.105949+0800 [Log-Development.swift : 35] 1234'
///
/// - Parameters:
///   - items: 要打印的item
///   - separator: 每个item的间隔符，默认是一个空格
///   - terminator: 打印到最后的结束符，默认是'\n'
///   - file: 值取自#file宏
///   - line: 值取自#line宏
func Log(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line) {
    let str = items.map { "\($0)" }.joined(separator: separator)
    print(formatDate(Date()), "[\(URL(fileURLWithPath: file).lastPathComponent) \(line)]", str, separator: separator, terminator: terminator, to: &output)
}
