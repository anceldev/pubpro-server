//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Vapor

struct JWTAuthenticator: AsyncRequestAuthenticator {
    func authenticate(request: Request) async throws {
        try await request.jwt.verify(as: AuthPayload.self)
    }
}
