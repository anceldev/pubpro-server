//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Fluent

final class CreateMovementsMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("movements")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("pub_item_id", .uuid, .required, .references("pub_items", "id"))
            .field("added_on", .datetime)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("movements")
            .delete()
    }
}
