//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 3/1/25.
//

import Vapor
import PubProSharedDTO

extension SignInResponseDTO: Content {
    
}


//struct SignInResponseDTO2: Codable, @unchecked Sendable, Content {
//    let error: Bool
//    var reason: String? = nil
//    var token: String? = nil
////    var userId: UUID? = nil
//    var user: UserResponseDTO
//    
//    init(error: Bool, reason: String? = nil, token: String? = nil, user: UserResponseDTO) {
//        self.error = error
//        self.reason = reason
//        self.token = token
////        self.userId = userId
//        self.user = user
//    }
//}
