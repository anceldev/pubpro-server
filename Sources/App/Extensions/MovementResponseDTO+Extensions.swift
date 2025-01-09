//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Vapor
import PubProSharedDTO

//struct MovementResponseDTO: Codable, Content, @unchecked Sendable {
//    let id: UUID
//    let userId: UserResponseDTO
//    let pubItem: PubItemResponseDTO
//    let addedOn: Date
//    
//    init(id: UUID, user: UserResponseDTO, pubItem: PubItemResponseDTO, addedOn: Date) {
//        self.id = id
//        self.userId = user
//        self.pubItem = pubItem
//        self.addedOn = addedOn
//    }
//}

extension MovementResponseDTO: Content {
    
    init?(_ movement: Movement) {
        guard let movementId = movement.id,
              let _ = movement.user.id,
              let _ = movement.pubItem.id,
              let addedOn = movement.addedOn
        else {
            return nil
        }
        
        self.init(
            id: movementId,
            user: UserResponseDTO(movement.user)!,
            pubItem: PubItemResponseDTO(movement.pubItem)!,
            addedOn: addedOn
        )
    }
}
