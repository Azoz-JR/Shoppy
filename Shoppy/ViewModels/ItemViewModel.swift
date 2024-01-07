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
    let vendor: String
    
    var count = 0
    var color = "N/A"
    var size = "N/A"
    
    init(id: Int, title: String, price: Double, discountPercentage: Double, category: Category?, image: URL?, images: [URL?], sizes: [String], colors: [ColorOption], description: String, vendor: String) {
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
        self.vendor = vendor
        
        self.color = colors.first?.rawValue ?? "N/A"
        self.size = sizes.first ?? "N/A"
    }
    
    mutating func increaseCount() {
        count += 1
    }
    
    mutating func decreaseCount() {
        count -= 1
    }
    
    mutating func selectSize(size: String) {
        self.size = size
    }
    
    mutating func selectColor(color: String) {
        self.color = color
    }
    
    static func ==(lhs: ItemViewModel, rhs: ItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
