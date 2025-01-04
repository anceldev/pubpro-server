//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Fluent
import Vapor

final class PasswordResetController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let passwordReset = routes.grouped("password-reset")
        
    }
    
    private let resetBaseLink = "http://127.0.0.1:8080/reset-password?token="
    
    func requestReset(req: Request) async throws -> HTTPStatus {
        struct ResetRequest: Content {
            let email: String
        }
        
        let resetRequest = try req.content.decode(ResetRequest.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == resetRequest.email)
            .first() else {
            throw Abort(.notFound)
        }
        let token = UUID().uuidString
        let resetToken = PasswordResetToken(
            token: token,
            userId: user.id!,
            expiresAt: Date().addingTimeInterval(3600)
        )
        
        try await resetToken.save(on: req.db)
        
        let resetLink = resetBaseLink + token
        print(resetLink)
        
//        let email = try await req.mailer.send
        
        let email = "Send email here"
        return .ok
    }
}
