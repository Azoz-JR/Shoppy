//
//  Collection.swift
//  Shoppy
//
//  Created by Azoz Salah on 20/12/2023.
//

import Foundation

// MARK: - Collections
struct Collections: Codable {
    let smartCollections: [SmartCollection]

    enum CodingKeys: String, CodingKey {
        case smartCollections = "smart_collections"
    }
}

// MARK: - SmartCollection
struct SmartCollection: Codable {
    let id: Int
    let title: String
    let image: Image
    
    func toItemViewModel() -> ItemViewModel {
        return ItemViewModel(id: id, title: title, price: 0, discountPercentage: 0, category: nil, image: imageURL, images: [], sizes: [], colors: [], description: "")
    }
    
    var imageURL: URL? {
        URL(string: image.src)
    }
}
