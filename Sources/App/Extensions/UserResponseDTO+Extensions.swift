//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 4/1/25.
//

import Foundation
import Vapor
import PubProSharedDTO


extension UserResponseDTO: Content {
    init?(_ user: User) {
        guard let userId = user.id,
              let userEmail = user.email,
              let userPoints = user.points,
              let userRole = user.role
        else {
            return nil
        }
        self.init(id: userId, username: user.username, email: userEmail, points: userPoints, role: userRole, createdAt: user.createdAt)
    }
}
