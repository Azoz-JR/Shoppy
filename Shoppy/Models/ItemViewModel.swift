//
//  ItemViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 19/12/2023.
//

import Foundation

struct ItemViewModel: Codable, Hashable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let discountPercentage: Double
    let category: Category
    let image: URL?
    let images: [URL?]
    let sizes: [String]
    let colors: [ColorOption]
    
    var count = 1
    
    init(product: Product, count: Int = 1) {
        self.id = product.id
        self.title = product.title
        self.price = product.prices.first ?? 0.0
        self.discountPercentage = 0.0
        self.category = product.productType
        self.image = product.imageURL
        self.images = product.imagesURLs
        self.sizes = product.sizes
        self.colors = product.colors
        self.count = count
    }
    
    mutating func increaseCount() {
        count += 1
    }
    
    mutating func decreaseCount() {
        count -= 1
    }
    
    //static let example = ProductViewModel(product: Product.example)
    
    static func ==(lhs: ItemViewModel, rhs: ItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
