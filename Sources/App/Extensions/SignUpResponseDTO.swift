//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Vapor

struct SignUpResponseDTO: Codable, @unchecked Sendable, Content {
    let error: Bool
    var reason: String? = nil
    
    init(error: Bool, reason: String? = nil) {
        self.error = error
        self.reason = reason
    }
}
