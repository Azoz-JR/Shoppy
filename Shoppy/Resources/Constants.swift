//
//  Constants.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import UIKit


struct Constants {
    static let baseURL = "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01"
    
    static let allProductsURL = baseURL + "/products.json"
    static let categoryProducts = baseURL + "/products.json?product_type="
    static let smartCollections = baseURL + "/smart_collections.json"
    static let collection = baseURL + "/products.json?vendor="
}

enum Category: String, Codable, CaseIterable {
    case accessories = "ACCESSORIES"
    case shoes = "SHOES"
    case tShirts = "T-SHIRTS"
}

enum ShoesSize: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case ten = "10"
    case eleven = "11"
    case twelve = "12"
    case thirteen = "13"
    case fourteen = "14"
    case fifteen = "15"
}

enum ClothesSize {
    case s
    case m
    case l
    case xl
}

enum ColorOption: String, Codable {
    case blue
    case black
    case white
    case red
    case gray
    case yellow
    case beige
    case lightBrown = "light_brown"
    case burgandy
    
    var color: UIColor {
        switch self {
        case .blue:
            UIColor.blue
        case .black:
            UIColor.black
        case .white:
            UIColor.white
        case .red:
            UIColor.systemRed
        case .gray:
            UIColor.systemGray
        case .yellow:
            UIColor.systemYellow
        case .beige:
            UIColor.beige
        case .lightBrown:
            UIColor.lightBrown
        case .burgandy:
            UIColor.burgundy
        }
    }
}

enum Vendor: String, CaseIterable {
    case adidas = "ADIDAS"
    case asicsTiger = "ASICS TIGER"
    case converse = "CONVERSE"
    case drMartens = "DR MARTENS"
    case flexFit = "FLEX FIT"
    case nike = "NIKE"
    case palladium = "PALLADIUM"
    case puma = "PUMA"
    case supra = "SUPRA"
    case timberland = "TIMBERLAND"
    case vans = "VANS"
}

let salesURLs: [URL?] = [
    URL(string: "https://th.bing.com/th/id/OIG3.RtV0LiIb8pYCiC0akxJh?pid=ImgGn"),
    URL(string: "https://th.bing.com/th/id/OIG3.paOY1pu_XG8XFbkrklBu?w=1024&h=1024&rs=1&pid=ImgDetMain"),
    URL(string: "https://th.bing.com/th/id/OIG3.8fJHNMluUlJxVe0XqPdt?pid=ImgGn")
]
