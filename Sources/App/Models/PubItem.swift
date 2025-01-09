//
//  File.swift
//  pubpro-server
//
//  Created by Ancel Dev account on 2/1/25.
//

import Foundation
import Fluent
import Vapor
import PubProSharedDTO

//enum ItemType: String, Codable {
//    case consumption
//    case reward
//}

final class PubItem: Model, Content, @unchecked Sendable {
    static let schema = "pub_items"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "points")
    var points: Int
    
    @Field(key: "price")
    var price: Double
    
    @Enum(key: "item_type")
    var itemType: ItemType
    
    @Children(for: \.$pubItem)
    var movements: [Movement]
    
    init(){}
    
    init(id: UUID? = nil, name: String, description: String, points: Int, price: Double, itemType: ItemType) {
        self.id = id
        self.name = name
        self.description = description
        self.points = points
        self.price = price
        self.itemType = itemType
    }
}
