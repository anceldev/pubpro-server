//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Vapor
import Fluent
import PubProSharedDTO

class UserController: RouteCollection, @unchecked Sendable {
    func boot(routes: any RoutesBuilder) throws {
        let api = routes.grouped("api")
        
        api.post("sign-up") { [self] req async throws -> SignUpResponseDTO in
            try await signUp(req: req)
        }
        
        api.post("sign-in") { [self] req async throws -> SignInResponseDTO in
            try await signIn(req: req)
        }
        
        let protected = api.grouped(JWTAuthenticator())
        protected.get("token-sign-in", ":userId") { [self] req async throws -> SignInResponseDTO in
            try await signInWithToken(req: req)
        }
    }
    
    func signInWithToken(req: Request) async throws -> SignInResponseDTO {
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.unauthorized)
        }

        guard let existingUser = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound)
        }

        let authPayload = try AuthPayload(
            subject: "vapor",
            expiration: .init(value: .distantFuture),
            userId: existingUser.requireID()
        )
        
        guard let userResponseDTO = UserResponseDTO(existingUser) else {
            throw Abort(.notFound)
        }
        let response = try await SignInResponseDTO(
            error: false,
            token: req.jwt.sign(authPayload),
            user: userResponseDTO
        )
        return response
    }
    
    /// Sign In a auser
    /// - Parameter req: request
    /// - Returns: ``SignInResponseDTO``
    func signIn(req: Request) async throws -> SignInResponseDTO {
        // Decode user request
        let user = try req.content.decode(User.self)
        
        guard let existingUser = try await User.query(on: req.db)
            .filter(\.$username == user.username)
            .first() else {
            throw Abort(.notFound)
        }
        
        let result = try await req.password.async.verify(user.password, created: existingUser.password)
        
        if !result {
            throw Abort(.unauthorized)
        }
        
        let authPayload = try AuthPayload(
            subject: "vapor",
            expiration: .init(value: .distantFuture),
            userId: existingUser.requireID()
        )
        guard let userResponseDTO = UserResponseDTO(existingUser) else {
            throw Abort(.notFound)
        }
        
        let response = try await SignInResponseDTO(
            error: false,
            token: req.jwt.sign(authPayload),
            user: userResponseDTO
        )
        
        return response
    }
    
    /// Sign ups a new user
    /// - Parameter req: request
    /// - Returns: ``SignInResponseDTO``
    func signUp(req: Request) async throws -> SignUpResponseDTO {
        // validate the user
        try User.validate(content: req)
        let user = try req.content.decode(User.self)
        // finde if the user already exists using the username
        if let _ = try await User.query(on: req.db)
            .filter(\.$email == user.email)
            .first() {
            throw Abort(.conflict, reason: "User with same email already exists.")
        }
        
        if let _ = try await User.query(on: req.db)
            .filter(\.$username == user.username)
            .first() {
            throw Abort(.conflict, reason: "User with same username already exists.")
        }
        
        user.password = try await req.password.async.hash(user.password)
        try await user.save(on: req.db)
        return SignUpResponseDTO(error: false)
    }
}
