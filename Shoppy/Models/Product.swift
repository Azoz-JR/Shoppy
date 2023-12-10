//
//  Product.swift
//  Shoppy
//
//  Created by Azoz Salah on 08/12/2023.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String
    let category: String
    let thumbnail: String
    let images: [String]
    
    static let example = Product(id: 1, title: "Title", description: "Description", price: 10, discountPercentage: 15, rating: 4, stock: 50, brand: "Apple", category: "Smart Phone", thumbnail: "", images: [])
}

struct ResultProducts: Codable {
    let products: [Product]
}
