//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Vapor
import Fluent

final class PubItemController: RouteCollection, @unchecked Sendable {
    func boot(routes: any RoutesBuilder) throws {
        let api = routes.grouped("api", "admin", ":userId").grouped(JWTAuthenticator())
        
        api.get("items") { [self] req async throws -> [PubItemResponseDTO] in
            try await getPubItems(req: req)
        }
        api.get("items", "consumption") { [self] req async throws -> [PubItemResponseDTO] in
            try await getConsumptionPubItems(req: req)
        }
        api.get("items", "reward") { [self] req async throws -> [PubItemResponseDTO] in
            try await getRewardsPubItems(req: req)
        }
        api.post("items") { [self] req async throws -> PubItemResponseDTO in
            try await savePubItem(req: req)
        }
    }
    
    func getConsumptionPubItems(req: Request) async throws -> [PubItemResponseDTO] {
        return try await PubItem.query(on: req.db)
            .filter(\.$itemType == ItemType.consumption)
            .all()
            .compactMap(PubItemResponseDTO.init)
    }
    func getRewardsPubItems(req: Request) async throws -> [PubItemResponseDTO] {
        return try await PubItem.query(on: req.db)
            .filter(\.$itemType == ItemType.reward)
            .all()
            .compactMap(PubItemResponseDTO.init)
    }
    
    func getPubItems(req: Request) async throws -> [PubItemResponseDTO] {
        return try await PubItem.query(on: req.db)
            .all()
            .compactMap(PubItemResponseDTO.init)
    }
    
    func savePubItem(req: Request) async throws -> PubItemResponseDTO {
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let user = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound)
        }
        
        if user.role != .admin { throw Abort(.unauthorized) }
        
        let pubItemDTO = try req.content.decode(PubItemRequestDTO.self)
        let pubItem = PubItem(
            name: pubItemDTO.name,
            description: pubItemDTO.description,
            points: pubItemDTO.points,
            price: pubItemDTO.price,
            itemType: pubItemDTO.itemType
        )
        try await pubItem.save(on: req.db)
        guard let pubItemResponseDTO = PubItemResponseDTO(pubItem) else {
            throw Abort(.internalServerError)
        }
        
        return pubItemResponseDTO
    }
}
