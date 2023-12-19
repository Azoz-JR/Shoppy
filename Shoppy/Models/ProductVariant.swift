//
//  ProductVariant.swift
//  Shoppy
//
//  Created by Azoz Salah on 19/12/2023.
//

import Foundation

struct Variant: Codable {
    let id, productID: Int
    let title, price, sku: String
    let position: Int
    let inventoryPolicy: InventoryPolicy
    let compareAtPrice: String?
    let fulfillmentService: FulfillmentService
    let inventoryManagement: InventoryManagement
    let option1: String
    let option2: Option2
    let createdAt, updatedAt: Date
    let taxable: Bool
    let grams: Int
    let weight: Int
    let weightUnit: WeightUnit
    let inventoryItemID, inventoryQuantity, oldInventoryQuantity: Int
    let requiresShipping: Bool
    let adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price, sku, position
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
        case fulfillmentService = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case option1, option2
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxable, grams
        case weight
        case weightUnit = "weight_unit"
        case inventoryItemID = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case requiresShipping = "requires_shipping"
        case adminGraphqlAPIID = "admin_graphql_api_id"
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
