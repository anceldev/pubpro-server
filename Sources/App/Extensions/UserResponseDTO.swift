//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Vapor

struct UserResponseDTO: Codable, @unchecked Sendable {
    let username: String
    let email: String
    let points: Int
    
    init(username: String, email: String, points: Int) {
        self.username = username
        self.email = email
        self.points = points
    }
}


extension UserResponseDTO: Content {
    
    init?(_ user: User) {
        guard let _ = user.id,
              let userEmail = user.email,
              let userPoints = user.points
        else {
            return nil
        }
        self.init(username: user.username, email: userEmail, points: userPoints)
    }
}
