//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Fluent
import Vapor

final class PasswordResetToken: Model, Content, @unchecked Sendable {
    static let schema = "password_reset_tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "token")
    var token: String
    
    @Field(key: "expires_at")
    var expiresAt: Date
    
    @Parent(key: "user_id")
    var user: User
    
    init(){}
    
    init(id: UUID? = nil, token: String, userId: UUID, expiresAt: Date) {
        self.id = id
        self.token = token
        self.$user.id = userId
        self.expiresAt = expiresAt
    }
}
