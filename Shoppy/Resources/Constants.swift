//
//  Constants.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import Foundation


struct Constants {
    static let allProductsURL = "https://dummyjson.com/products?limit=100&skip=0"
    static let categoryProducts = "https://dummyjson.com/products/category/"
}


enum Category: String, CaseIterable {
    case smartphones
    case laptops
    case fragrances
    case skincare
    case groceries
    case homeDecoration = "home-decoration"
    case furniture
    case tops
    case womensDresses = "womens-dresses"
    case womensShoes = "womens-shoes"
    case mensShirts = "mens-shirts"
    case mensWatches = "mens-watches"
    case womensWatches = "womens-watches"
    case womensBags = "womens-bags"
    case womensJewellery = "womens-jewellery"
    case sunglasses
    case automotive
    case motorcycle
    case lighting
}
