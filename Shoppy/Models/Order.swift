//
//  Order.swift
//  Shoppy
//
//  Created by Azoz Salah on 27/12/2023.
//

import Foundation

struct Order: Equatable, Codable {
    let id: UUID
    let items: [ItemViewModel]
    let price: Double
    let date: Date
    
    var image: URL? {
        return items.first?.image
    }
    
    var formattedDate: String {
        date.formatted(date: .abbreviated, time: .shortened)
    }
    
    static func ==(lhs: Order, rhs: Order) -> Bool {
        lhs.id == rhs.id
    }
}
