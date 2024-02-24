//
//  Collections.swift
//  Shoppy
//
//  Created by Azoz Salah on 24/02/2024.
//

import Foundation

struct Collections: Codable {
    let smartCollections: [SmartCollection]

    enum CodingKeys: String, CodingKey {
        case smartCollections = "smart_collections"
    }
}
