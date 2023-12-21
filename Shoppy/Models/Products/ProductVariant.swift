//
//  ProductVariant.swift
//  Shoppy
//
//  Created by Azoz Salah on 19/12/2023.
//

import Foundation

struct Variant: Codable {
    let id: Int
    let title, price: String
    let position: Int
    let option1: String
    let option2: Option2
    let taxable: Bool
    let grams: Int
    let weight: Int
    let weightUnit: WeightUnit

    enum CodingKeys: String, CodingKey {
        case id
        case title, price, position
        case option1, option2
        case taxable, grams
        case weight
        case weightUnit = "weight_unit"
    }
}

enum FulfillmentService: String, Codable {
    case manual = "manual"
}

enum InventoryManagement: String, Codable {
    case shopify = "shopify"
}

enum InventoryPolicy: String, Codable {
    case deny = "deny"
}

enum Option2: String, Codable {
    case beige = "beige"
    case black = "black"
    case blue = "blue"
    case burgandy = "burgandy"
    case gray = "gray"
    case lightBrown = "light_brown"
    case red = "red"
    case white = "white"
    case yellow = "yellow"
}

enum WeightUnit: String, Codable {
    case kg = "kg"
}
