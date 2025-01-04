//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Fluent
import Vapor

enum UserRole: String, Codable {
    case admin
    case user
}

final class User: Model, Content, Validatable, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "email")
    var email: String? //
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "points")
    var points: Int? //
    
    @Children(for: \.$user)
    var movements: [Movement]
    
    @OptionalEnum(key: "role")
    var role: UserRole?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init(){}
    
    init(id: UUID? = nil, username: String, email: String, password: String, points: Int = 0, role: UserRole? = .user, createdAt: Date?, userId: UUID) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.points = points
        self.role = role
        self.createdAt = createdAt
    }
    
    static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: !.empty, customFailureDescription: "Username cannot be empty.")
        validations.add("email", as: String.self, is: .email, customFailureDescription: "Invalid email format")
        validations.add("password", as: String.self, is: !.empty, customFailureDescription: "Password cannot be empty")
        validations.add("password", as: String.self, is: .count(4...10), customFailureDescription: "Password must be between 6 and 10 characters long")
//        validations.add("points", as: Int.self, is: .valid, customFailureDescription: "Points field must be an integer.")
        validations.add("points", as: Int?.self, is: .valid, customFailureDescription: "Points must be an integer")
    }
}
