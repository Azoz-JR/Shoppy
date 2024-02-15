//
//  CollectionViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 10/01/2024.
//

import Foundation

class CollectionViewModel {
    var service: Service?
    var products: MyObservable<[ItemModel]> = MyObservable([])
    var error: MyObservable<Error> = MyObservable(nil)
    
    
    func load() async {
        do {
            guard let products = try await service?.loadProducts() else {
                return
            }
            
            await MainActor.run {
                self.products.value = products
            }
            
        } catch {
            await MainActor.run {
                self.error.value = error
            }
        }
    }
}
