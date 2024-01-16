//
//  ItemModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 19/12/2023.
//

import Foundation

struct ItemModel: Codable, Hashable, Equatable {
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
    
    static func ==(lhs: ItemModel, rhs: ItemModel) -> Bool {
        lhs.id == rhs.id
    }
    
    init(from dictionary: [String: Any]) {
        id = dictionary["id"] as? Int ?? 0
        title = dictionary["title"] as? String ?? ""
        price = dictionary["price"] as? Double ?? 0.0
        discountPercentage = dictionary["discountPercentage"] as? Double ?? 0.0
        category = Category(rawValue: dictionary["category"] as? String ?? "")
        image = URL(string: dictionary["image"] as? String ?? "")
        images = (dictionary["images"] as? [String])?.compactMap { URL(string: $0) } ?? []
        sizes = dictionary["sizes"] as? [String] ?? []
        colors = (dictionary["colors"] as? [String])?.map { ColorOption(rawValue: $0) } as? [ColorOption] ?? []
        description = dictionary["description"] as? String ?? ""
        vendor = dictionary["vendor"] as? String ?? ""
        count = dictionary["count"] as? Int ?? 0
        size = dictionary["size"] as? String ?? ""
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "price": price,
            "discountPercentage": discountPercentage,
            "category": category?.rawValue ?? "N/A", // Assuming Category is an enum with a rawValue
            "image": image?.absoluteString ?? "N/A",
            "images": images.map { $0?.absoluteString ?? "N/A" },
            "sizes": sizes,
            "colors": colors.map { $0.rawValue }, // Assuming ColorOption has a toDictionary method
            "description": description,
            "vendor": vendor,
            "count": count,
            "color": color,
            "size": size
        ]
    }
}
