//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import JWT

struct AuthPayload: JWTPayload {
    
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case userId = "uid"
    }
    
    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var userId: UUID

    func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
        try self.expiration.verifyNotExpired()
    }
}
