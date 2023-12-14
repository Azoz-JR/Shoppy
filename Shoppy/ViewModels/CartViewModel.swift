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
            total += product.price
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
    
    func addPorduct(product: ProductViewModel) {
        //product.increaseCount()
    }
    
    func removeProduct(product: ProductViewModel) {
//        guard product.count > 1 else {
//            cartProducts.value?.removeAll(where: { $0 == product})
//        }
//        
//        if let index = cartProducts.value?.firstIndex(where: {$0 == product}) {
//            cartProducts.value?.remove(at: index)
//        }
    }
    
    func removeAllItems(of product: ProductViewModel) {
        cartProducts.value?.removeAll(where: { $0 == product })
    }
    
}
