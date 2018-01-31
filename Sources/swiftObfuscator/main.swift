import Foundation
import SwiftSyntax
import ObjectiveC.runtime

struct _ABC: Syntax {

}

func foo() {
    // Parse a .swift file
    let currentFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("123.swift")
    do {

        let parsed = try _ABC.parse(currentFile)

        var textStream = String()

        let R = Renamer()

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

foo()
