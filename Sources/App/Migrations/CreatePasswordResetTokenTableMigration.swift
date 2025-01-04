//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Fluent

final class CreatePasswordResetTokenTableMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(PasswordResetToken.schema)
            .id()
            .field("token", .string, .required)
            .field("user_id", .uuid, .required, .references(User.schema, "id"))
            .field("expires_at", .datetime, .required)
            .create()
    }
    func revert(on database: any Database) async throws {
        try await database.schema(PasswordResetToken.schema).delete()
    }
}
