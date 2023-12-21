//
//  ProductsAPIProductsServiceAdapter.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import Foundation

struct ProductsAPIServiceAdapter: Service {
    let api: ProductsAPI
    let category: String?
    
    init(api: ProductsAPI, category: String? = nil) {
        self.api = api
        self.category = category
    }
    
    
    func loadProducts(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        if let category = category {
            api.loadCategoryProducts(category: category) { results in
                DispatchQueue.mainAsyncIfNeeded {
                    completion(results.map({ products in
                        return products.map { product in
                            product.toItemViewModel()
                        }
                    }))
                }
            }
        } else {
            api.loadProducts { results in
                DispatchQueue.mainAsyncIfNeeded {
                    completion(results.map({ products in
                        return products.map { product in
                            product.toItemViewModel()
                        }
                    }))
                }
            }
        }
    }
}