//
//  ProductOption.swift
//  Shoppy
//
//  Created by Azoz Salah on 19/12/2023.
//

import Foundation

struct Option: Codable {
    let id, productID: Int
    let name: Name
    let position: Int
    let values: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position, values
    }
}

enum Name: String, Codable {
    case color = "Color"
    case size = "Size"
}

enum PublishedScope: String, Codable {
    case global = "global"
}

enum Status: String, Codable {
    case active = "active"
}
