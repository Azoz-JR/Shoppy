//
//  Item.swift
//  Shoppy
//
//  Created by Azoz Salah on 19/12/2023.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title, vendor, bodyHtml: String
    let productType: Category
    let tags: String
    let status: Status
    let variants: [Variant]
    let options: [Option]
    let images: [Image]
    let image: Image

    enum CodingKeys: String, CodingKey {
        case id, title
        case vendor
        case bodyHtml = "body_html"
        case productType = "product_type"
        case tags, status
        case variants, options, images, image
    }
    
    func toItemModel() -> ItemModel {
        ItemModel(id: id, title: title, price: prices.first ?? 0
                      , discountPercentage: 0, category: productType, image: imageURL, images: imagesURLs, sizes: sizes, colors: colors, description: bodyHtml, vendor: vendor)
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
