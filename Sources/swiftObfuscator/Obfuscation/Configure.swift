//
//  Configure.swift
//  swiftObfuscator
//
//  Created by hejunqiu on 2018/3/3.
//

import Foundation

struct Configure: Decodable {
    static let shared = Configure._shared()
    struct PathNode: Decodable {
        var mainPath: String
        var ignoreFilepath: [String]
    }
    var path: PathNode?

    struct KeepNode: Decodable {
        var clazz: String
        var function: [String]?
        var properties: [String]?
    }

    var keep: [KeepNode]?

    private static func _shared() -> Configure {
        if CommandLine.argc == 2 {
            do {
                let data = try Data(contentsOf: URL(string: CommandLine.arguments.last!)!)
                let config = try JSONDecoder().decode(Configure.self, from: data)
                return config
            } catch {
                print(error)
                exit(2)
            }
        } else {
            return Configure()
        }
    }

    var isDebug: Bool

    func debug(code: () -> Void) {
        isDebug ? code() : ()
    }

    enum CodingKeys: String, CodingKey {
        case path, keep, isDebug
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        path = try? container.decode(PathNode.self, forKey: .path)
        keep = try? container.decode([KeepNode].self, forKey: .keep)
        if let bool = try? container.decode(Bool.self, forKey: .isDebug) {
            isDebug = bool
        } else {
            isDebug = false
        }
    }

    private init() {
        isDebug = true
    }
}
