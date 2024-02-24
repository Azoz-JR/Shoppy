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






