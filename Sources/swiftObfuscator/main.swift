import Foundation
import SwiftSyntax
import ObjectiveC.runtime

func foo() {
    struct ABC: Syntax {

    }
    // Parse a .swift file
    let currentFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("123.swift")
    do {

        let parsed = try ABC.parse(currentFile)

        var textStream = String()

        let R = RenamerFoo()

        // Print the file after renaming
        textStream.append("\n//======== Renamed =========\n")
        textStream.append(R.visit(parsed).description)

        let filepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("filechanged.swift")
        try textStream.write(to: filepath, atomically: true, encoding: .utf8)
    } catch {
        print(error)
    }
    print("...End...")
}

//var obs = Obfuscator(filepaths: [FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("123.swift")])
//obs.start()

//foo()

let reg = try! NSRegularExpression(pattern: "(?<=^(我要)?)(眼圈|厌倦|烟圈|验圈|烟卷|源泉|圆圈|袁泉)", options: .init(rawValue: 0))
let search = "我要眼圈"
let str = reg.stringByReplacingMatches(in: search, options: .reportProgress, range: .init(location: 0, length: search.count), withTemplate: "验券")
print(str)
