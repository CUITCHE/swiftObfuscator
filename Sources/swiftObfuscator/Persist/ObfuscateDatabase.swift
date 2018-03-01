//
//  ObfuscateDatabase.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/3/1.
//

import Foundation
import SQLite

struct ObfuscateDatabase {
    let db: Connection

    struct ClazzTable {
        let table = Table("clazz")
        let id = SQLite.Expression<Int64>("id")
        let inheritance = SQLite.Expression<String>("inheritance")
        let name = SQLite.Expression<String>("name")
        let obfus = SQLite.Expression<String>("obfus")

        init(runIn db: Connection) throws {
            try db.run(table.create(ifNotExists: true, block: { t in
                t.column(id, primaryKey: true)
                t.column(inheritance)
                t.column(name)
                t.column(obfus)
            }))
        }
    }

    struct ExtensionTable {
        let table = Table("extension")
        let id = SQLite.Expression<Int64>("id")
        let inheritance = SQLite.Expression<String>("inheritance")
        let name = SQLite.Expression<String>("name")

        init(runIn db: Connection) throws {
            try db.run(table.create(ifNotExists: true, block: { t in
                t.column(id, primaryKey: true)
                t.column(inheritance)
                t.column(name)
            }))
        }
    }

    struct ProtocolTable {
        let table = Table("protocol")
        let id = SQLite.Expression<Int64>("id")
        let inheritance = SQLite.Expression<String>("inheritance")
        let name = SQLite.Expression<String>("name")
        let obfus = SQLite.Expression<String>("obfus")

        init(runIn db: Connection) throws {
            try db.run(table.create(ifNotExists: true, block: { t in
                t.column(id, primaryKey: true)
                t.column(inheritance)
                t.column(name)
                t.column(obfus)
            }))
        }
    }

    struct PropertyTable {
        let table = Table("property")
        let id = SQLite.Expression<Int64>("id")
        let name = SQLite.Expression<String>("name")
        let nobfus = SQLite.Expression<String>("nobfus")
        let type = SQLite.Expression<String>("type")
        let tobfus = SQLite.Expression<String>("tobfus")
    }
}
