//
//  ProductImage.swift
//  Shoppy
//
//  Created by Azoz Salah on 19/12/2023.
//

import Foundation

struct Image: Codable {
    let id: Int
    let position, productID: Int
    let createdAt, updatedAt: Date
    let adminGraphqlAPIID: String
    let width, height: Int
    let src: String

    enum CodingKeys: String, CodingKey {
        case id, position
        case productID = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case width, height, src
    }
}
