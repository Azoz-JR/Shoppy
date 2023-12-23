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
    let category: Category?
    let image: URL?
    let images: [URL?]
    let sizes: [String]
    let colors: [ColorOption]
    let description: String
    
    var count = 0
    var liked = false
    
    init(id: Int, title: String, price: Double, discountPercentage: Double, category: Category?, image: URL?, images: [URL?], sizes: [String], colors: [ColorOption], description: String) {
        self.id = id
        self.title = title
        self.price = price
        self.discountPercentage = discountPercentage
        self.category = category
        self.image = image
        self.images = images
        self.sizes = sizes
        self.colors = colors
        self.description = description
    }
    
    mutating func increaseCount() {
        count += 1
    }
    
    mutating func decreaseCount() {
        count -= 1
    }
    
    mutating func likeProduct() {
        liked = true
    }
    
    mutating func unLikeProduct() {
        liked = false
    }
    
    //static let example = ProductViewModel(product: Product.example)
    
    static func ==(lhs: ItemViewModel, rhs: ItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
