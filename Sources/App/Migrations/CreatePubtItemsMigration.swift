//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Fluent

final class CreatePubItemsMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        let itemType = try await database.enum("movementType")
            .case("consumption")
            .case("reward")
            .create()
        
        try await database.schema("pub_items")
            .id()
            .field("name", .string, .required)
            .field("description", .string)
            .field("points", .int, .required)
            .field("price", .double, .required)
            .field("item_type", itemType, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("pub_items")
            .delete()
    }
}
