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
    let total: Double
    let subTotal: Double
    let discount: Double
    let promoCode: String?
    let date: Date
    let address: Address
    
    init(id: String, items: [ItemModel], total: Double, subTotal: Double, discount: Double = 0.0, promoCode: String? = nil, date: Date, address: Address) {
        self.id = id
        self.items = items
        self.total = total
        self.subTotal = subTotal
        self.discount = discount
        self.promoCode = promoCode
        self.date = date
        self.address = address
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case items
        case total
        case subTotal = "sub_total"
        case discount
        case promoCode = "promo_code"
        case date
        case address
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.items, forKey: .items)
        try container.encode(self.total, forKey: .total)
        try container.encode(self.subTotal, forKey: .subTotal)
        try container.encode(self.discount, forKey: .discount)
        try container.encodeIfPresent(self.promoCode, forKey: .promoCode)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.address, forKey: .address)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.items = try container.decode([ItemModel].self, forKey: .items)
        self.total = try container.decode(Double.self, forKey: .total)
        self.subTotal = try container.decode(Double.self, forKey: .subTotal)
        self.discount = try container.decode(Double.self, forKey: .discount)
        self.promoCode = try container.decodeIfPresent(String.self, forKey: .promoCode)
        self.date = try container.decode(Date.self, forKey: .date)
        self.address = try container.decode(Address.self, forKey: .address)
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
    
}
