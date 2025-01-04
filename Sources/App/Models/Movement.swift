//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Fluent
import Vapor

final class Movement: Model, Content, @unchecked Sendable {
    static let schema = "movements"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "pub_item_id")
    var pubItem: PubItem
    
    @Timestamp(key: "added_on", on: .create)
    var addedOn: Date?
    
    init(){}
    
    init(id: UUID? = nil, userId: UUID, pubItemId: UUID) {
        self.id = id
        self.$user.id = userId //userId = userId
        self.$pubItem.id = pubItemId    //self.pubItem = pubItem
        self.addedOn = addedOn
    }
}
