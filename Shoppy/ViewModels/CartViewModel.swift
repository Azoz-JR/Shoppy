//
//  CartViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 12/12/2023.
//

import Foundation

class CartViewModel {
    var cartProducts: Observable<[ProductViewModel]> = Observable([])
    var cartCount: Observable<Int> = Observable(0)
    
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
        
    func addProduct(product: ProductViewModel) {
        guard let products = cartProducts.value else {
            return
        }
        
        guard products.contains(product) else {
            cartProducts.value?.insert(product, at: 0)
            updateCount()
            return
        }
        
        if let index = products.firstIndex(of: product) {
            increaseProduct(at: index)
        }
        
    }
    
    func removeProduct(product: ProductViewModel) {
        guard let index = cartProducts.value?.firstIndex(of: product) else {
            return
        }
        
        guard let count = cartProducts.value?[index].count, count > 1 else {
            removeProduct(at: index)
            return
        }
        
        cartProducts.value?[index].decreaseCount()
        updateCount()
    }
    
    private func increaseProduct(at index: Int) {
        cartProducts.value?[index].increaseCount()
        updateCount()
    }
    
    func removeProduct(at index: Int) {
        cartProducts.value?.remove(at: index)
        updateCount()
    }
    
    func contains(product: ProductViewModel) -> Bool {
        guard let products = cartProducts.value, products.contains(product) else {
            return false
        }
        
        return true
    }
    
    func updateCount() {
        guard let products = cartProducts.value else {
            return
        }
        var count = 0
        
        products.forEach { item in
            count += item.count
        }
        
        cartCount.value = count
    }
    
}
