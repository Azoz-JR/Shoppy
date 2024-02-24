//
//  SmartCollection.swift
//  Shoppy
//
//  Created by Azoz Salah on 24/02/2024.
//

import Foundation


struct SmartCollection: Codable {
    let id: Int
    let title: String
    let image: Image
    
    func toItemModel() -> ItemModel {
        return ItemModel(id: id, title: title, price: 0, discountPercentage: 0, category: nil, image: imageURL, images: [], sizes: [], colors: [], description: "", vendor: title)
    }
    
    var imageURL: URL? {
        URL(string: image.src)
    }
}
