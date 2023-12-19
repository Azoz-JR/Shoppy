//
//  Item.swift
//  Shoppy
//
//  Created by Azoz Salah on 19/12/2023.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title, vendor: String
    let productType: Category
    let createdAt: Date
    let handle: String
    let updatedAt, publishedAt: Date
    let publishedScope: PublishedScope
    let tags: String
    let status: Status
    let adminGraphqlAPIID: String
    let variants: [Variant]
    let options: [Option]
    let images: [Image]
    let image: Image

    enum CodingKeys: String, CodingKey {
        case id, title
        case vendor
        case productType = "product_type"
        case createdAt = "created_at"
        case handle
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case publishedScope = "published_scope"
        case tags, status
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case variants, options, images, image
    }
    
    func toItemViewModel() -> ItemViewModel {
        ItemViewModel(product: self)
    }
    
    var imageURL: URL? {
        URL(string: image.src)
    }
    
    var imagesURLs: [URL] {
        return images.compactMap { image in
            URL(string: image.src)
        }
    }
    
    var prices: [Double] {
        return variants.compactMap { product in
            try? Double(product.price, format: .number)
        }
    }
    
    var colors: [ColorOption] {
        guard let colors = options.filter({ $0.name == .color }).first?.values else {
            return []
        }
        return colors.compactMap { color in
            ColorOption(rawValue: color)
        }
    }
    
    var sizes: [String] {
        guard let sizes = options.filter({ $0.name == .size }).first?.values else {
            return []
        }
        return sizes
    }
    
}
