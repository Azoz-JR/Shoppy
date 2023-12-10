//
//  ProductsAPIProductsServiceAdapter.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import Foundation

struct ProductsAPIProductsServiceAdapter: ProductsService {
    let api: ProductsAPI
    let category: Category?
    
    init(api: ProductsAPI, category: Category? = nil) {
        self.api = api
        self.category = category
    }
    
    
    func loadProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        if let category = category {
            api.loadCategoryProducts(category: category) { results in
                DispatchQueue.mainAsyncIfNeeded {
                    completion(results)
                }
            }
        } else {
            api.loadProducts { results in
                DispatchQueue.mainAsyncIfNeeded {
                    completion(results)
                }
            }
        }
    }
}
