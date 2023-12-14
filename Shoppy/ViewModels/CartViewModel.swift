//
//  CartViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 12/12/2023.
//

import Foundation

class CartViewModel {
    var cartProducts: Observable<[ProductViewModel]> = Observable([])
    
    var total: Double {
        guard let products = cartProducts.value, !products.isEmpty else {
            return 0.0
        }
        
        var total = 0.0
        products.forEach { product in
            total += product.price * Double(product.count)
        }
        
        return total
    }
    
    func loadProducts() {
        let api = ProductsAPIProductsServiceAdapter(api: ProductsAPI.shared, category: .homeDecoration)
        api.loadProducts(completion: handleAPIResults)
    }
    
    func handleAPIResults(_ result: Result<[Product], Error>) {
        switch result {
        case .success(let products):
            let cartProducts = products.map { item in
                item.toProductViewModel()
            }
            
            self.cartProducts.value = cartProducts
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func increaseProduct(at index: IndexPath) {
        cartProducts.value?[index.row].increaseCount()
    }
    
    func decreseProduct(at index: IndexPath) {
        guard let count = cartProducts.value?[index.row].count, count > 1 else {
            removeProduct(at: index)
            return
        }
        
        cartProducts.value?[index.row].decreaseCount()
    }
    
    func removeProduct(at index: IndexPath) {
        cartProducts.value?.remove(at: index.row)
    }
    
}
