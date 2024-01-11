//
//  CollectionsAPIServiceAdapter.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import Foundation

struct CollectionsAPIServiceAdapter: Service {
    let api: CollectionsAPI
    
    
    func loadProducts() async throws -> [ItemViewModel] {
        do {
            let collections = try await api.loadCollections()
            return collections.map { $0.toItemViewModel() }
        } catch {
            throw error
        }
    }
    
//    func loadProducts(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
//        api.loadCollections { results in
//            DispatchQueue.mainAsyncIfNeeded {
//                completion(results.map({ collections in
//                    return collections.map { collection in
//                        collection.toItemViewModel()
//                    }
//                }))
//            }
//        }
//    }
    
}
