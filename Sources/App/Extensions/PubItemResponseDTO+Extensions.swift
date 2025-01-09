//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Vapor
import PubProSharedDTO
//struct PubItemResponseDTO: Codable, @unchecked Sendable {
//    let id: UUID
//    let name: String
//    let description: String
//    let points: Int
//    let price: Double
//    let movementType: ItemType
//    
//    init(id: UUID, name: String, description: String, points: Int, price: Double, movementType: ItemType) {
//        self.id = id
//        self.name = name
//        self.description = description
//        self.points = points
//        self.price = price
//        self.movementType = movementType
//    }
//}

extension PubItemResponseDTO: Content {
    init?(_ pubItem: PubItem) {
        guard let pubItemId = pubItem.id else {
            return nil
        }
        self.init(
            id: pubItemId,
            name: pubItem.name,
            description: pubItem.description,
            points: pubItem.points,
            price: pubItem.price,
            movementType: pubItem.itemType
        )
    }
}
