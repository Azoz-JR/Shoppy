//
//  ProductsViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 12/12/2023.
//

import Foundation

struct ProductViewModel: Codable, Hashable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let discountPercentage: Double
    let category: String
    let thumbnail: String

    var count = 1
    
    init(product: Product, count: Int = 1) {
        self.id = product.id
        self.title = product.title
        self.price = product.price
        self.discountPercentage = product.discountPercentage
        self.category = product.category
        self.thumbnail = product.thumbnail
        self.count = count
    }
    
    var imageURL: URL? {
        URL(string: thumbnail)
    }
    
    mutating func increaseCount() {
        count += 1
    }
    
    mutating func decreaseCount() {
        count -= 1
    }
    
    static let example = ProductViewModel(product: Product.example)
    
    static func ==(lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
