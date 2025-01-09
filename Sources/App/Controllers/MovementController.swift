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

final class MovementController: RouteCollection, @unchecked Sendable {
    func boot(routes: any RoutesBuilder) throws {
        let api = routes.grouped("api", "users", ":userId").grouped(JWTAuthenticator())
        
        api.get("movements") { [self] req async throws -> [MovementResponseDTO] in
            try await getMovementsByUser(req: req)
        }
        
        api.post("movements") { [self] req async throws -> MovementResponseDTO in
            try await saveMovement(req: req)
        }
    }
    
    func getMovementsByUser(req: Request) async throws ->[MovementResponseDTO] {
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let movements = try await Movement.query(on: req.db)
            .filter(\.$user.$id == userId)
            .with(\.$user)
            .with(\.$pubItem)
            .all()
        return movements.compactMap(MovementResponseDTO.init)
    }
    
    func saveMovement(req: Request) async throws -> MovementResponseDTO {
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let existingUser = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound)
        }
        guard let userRole = existingUser.role, userRole == .admin else {
            throw Abort(.unauthorized)
        }
        
        let movementRequestDTO = try req.content.decode(MovementRequestDTO.self)
        guard let userRequestId = UUID(uuidString: movementRequestDTO.userId),
              let pubItemRequestId = UUID(uuidString: movementRequestDTO.pubItemId) else {
            throw Abort(.badRequest)
        }
        
        guard let pubItem = try await PubItem.query(on: req.db)
            .filter(\.$id == pubItemRequestId)
            .first() else {
            throw Abort(.notFound)
        }

        let movement = Movement(
            userId: userRequestId,
            pubItemId: pubItemRequestId
        )
        try await movement.save(on: req.db)
        try await movement.$pubItem.load(on: req.db)
        
        let currentPoints = existingUser.points ?? 0
        let totalPoints = movement.pubItem.itemType == .consumption ? currentPoints + pubItem.points : currentPoints - pubItem.points
        
        existingUser.points = totalPoints
        try await existingUser.save(on: req.db)
        
        try await movement.$user.load(on: req.db)
        
        guard let movementResponseDTO = MovementResponseDTO(movement) else {
            throw Abort(.internalServerError)
        }
        return movementResponseDTO
    }
}
