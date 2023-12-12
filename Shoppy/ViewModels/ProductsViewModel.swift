//
//  ProductsViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 12/12/2023.
//

import Foundation

class ProductsViewModel {
    var productsService: ProductsService?
    var products: Observable<[Product]> = Observable([])
    
    
    
    func loadProducts() {
        productsService?.loadProducts(completion: handleAPIResults)
    }
    
    func handleAPIResults(_ result: Result<[Product], Error>) {
        switch result {
        case .success(let products):
            self.products.value = products
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
