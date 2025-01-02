//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Vapor

struct SignInResponseDTO: Codable, @unchecked Sendable, Content {
    let error: Bool
    var reason: String? = nil
    var token: String? = nil
    var userId: UUID? = nil
    
    init(error: Bool, reason: String? = nil, token: String? = nil, userId: UUID? = nil) {
        self.error = error
        self.reason = reason
        self.token = token
        self.userId = userId
    }
}
