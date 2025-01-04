//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Vapor

struct MovementRequestDTO: Content {
    let userId: String
    let pubItemId: String
    
    init(userId: String, pubItemId: String) {
        self.userId = userId
        self.pubItemId = pubItemId
    }
}
