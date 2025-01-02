//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Fluent

struct CreateUsersTableMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("users")
            .id()
            .field("username", .string, .required).unique(on: "username")
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("points", .int)
            .field("role", .string, .required)
            .field("created_at", .datetime)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("users")
            .delete()
    }
}
