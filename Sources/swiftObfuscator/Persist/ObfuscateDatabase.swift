//
//  ObfuscateDatabase.swift
//  swiftObfuscator
//
//  Created by He,Junqiu on 2018/3/1.
//

import Foundation
import SQLite
import ObjectiveC

struct ObfuscateDatabase {
    let db: Connection

    struct ClazzTable {
        let table = Table("clazz")

        let id = SQLite.Expression<Int64>("id")
        let inheritance = SQLite.Expression<String?>("inheritance")
        let name = SQLite.Expression<String>("name")
        let obfus = SQLite.Expression<String>("obfus")

        let conformsProtocol = SQLite.Expression<String?>("conforms_protocol") // ids of conforming to protocol, separated by ','
        let properties = SQLite.Expression<String?>("properties") // ids of properties, separaed by ','
        let functions = SQLite.Expression<String?>("functions") // ids of functions, separaed by ','

        init(runIn db: Connection) throws {
            try db.run(table.create(ifNotExists: true, block: { t in
                t.column(id, primaryKey: true)
                t.column(inheritance)
                t.column(name)
                t.column(obfus)
                t.column(conformsProtocol)
                t.column(properties)
                t.column(functions)
            }))
        }
    }

    struct ExtensionTable {
        let table = Table("extension")

        let id = SQLite.Expression<Int64>("id")
        let inheritance = SQLite.Expression<String?>("inheritance")
        let name = SQLite.Expression<String>("name") // obfuscated name

        let conformsProtocol = SQLite.Expression<String?>("conforms_protocol") // ids of conforming to protocol, separated by ','
        let properties = SQLite.Expression<String?>("properties") // ids of properties, separaed by ','
        let functions = SQLite.Expression<String?>("functions") // ids of functions, separaed by ','

        init(runIn db: Connection) throws {
            try db.run(table.create(ifNotExists: true, block: { t in
                t.column(id, primaryKey: true)
                t.column(inheritance)
                t.column(name)
                t.column(conformsProtocol)
                t.column(properties)
                t.column(functions)
            }))
        }
    }

    struct ProtocolTable {
        let table = Table("protocol")

        let id = SQLite.Expression<Int64>("id")
        let inheritance = SQLite.Expression<String>("inheritance")
        let name = SQLite.Expression<String>("name")
        let obfus = SQLite.Expression<String>("obfus") // obfuscated name

        let conformsProtocol = SQLite.Expression<String?>("conforms_protocol") // ids of conforming to protocol, separated by ','
        let properties = SQLite.Expression<String?>("properties") // ids of properties, separaed by ','
        let functions = SQLite.Expression<String?>("functions") // ids of functions, separaed by ','

        init(runIn db: Connection) throws {
            try db.run(table.create(ifNotExists: true, block: { t in
                t.column(id, primaryKey: true)
                t.column(inheritance)
                t.column(name)
                t.column(obfus)
                t.column(conformsProtocol)
                t.column(properties)
                t.column(functions)
            }))
        }
    }

    struct PropertyTable {
        let table = Table("property")

        let id = SQLite.Expression<Int64>("id")
        let name = SQLite.Expression<String>("name")
        let obfus = SQLite.Expression<String>("obfus") // obfuscated name
        let type = SQLite.Expression<Int64>("type") // id of type

        init(runIn db: Connection) throws {
            try db.run(table.create(ifNotExists: true, block: { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(obfus)
                t.column(type)
            }))
        }
    }

    struct FunctionTable {
        let table = Table("function")

        let id = SQLite.Expression<Int64>("id")

        let name = SQLite.Expression<String>("name")
        let nobfus = SQLite.Expression<String>("nobfus") // obfuscated name

        let signatureLabel = SQLite.Expression<String?>("signature_label") // values are separated by ','
        let obfusLabel = SQLite.Expression<String?>("obfus_label") // Same to signature
        let types = SQLite.Expression<String?>("type") // ids of types, [UILabel, XXCustom, ...] map labels

        init(runIn db: Connection) throws {
            try db.run(table.create(ifNotExists: true, block: { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(nobfus)
                t.column(signatureLabel)
                t.column(obfusLabel)
                t.column(types)
            }))
        }
    }

    let clazzs: ClazzTable
    let extensions: ExtensionTable
    let protocols: ProtocolTable
    let properties: PropertyTable
    let functions: FunctionTable

    init(dbPath: String) throws {
        db = try Connection(dbPath)
        clazzs = try .init(runIn: db)
        extensions = try .init(runIn: db)
        protocols = try .init(runIn: db)
        properties = try .init(runIn: db)
        functions = try .init(runIn: db)
    }
}
