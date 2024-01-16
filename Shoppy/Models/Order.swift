//
//  Order.swift
//  Shoppy
//
//  Created by Azoz Salah on 27/12/2023.
//

import Foundation

struct Order: Equatable, Codable {
    let id: String
    let items: [ItemModel]
    let price: Double
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case items
        case price
        case date
    }
    
    var image: URL? {
        return items.first?.image
    }
    
    var formattedDate: String {
        date.formatted(date: .abbreviated, time: .shortened)
    }
    
    static func ==(lhs: Order, rhs: Order) -> Bool {
        lhs.id == rhs.id
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id" : id,
            "items" : items.map{ $0.toDictionary() },
            "price" : price,
            "date" : date
        ]
    }
    
}
