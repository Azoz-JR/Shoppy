//
//  ProductsViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 12/12/2023.
//

import Foundation

class ProductsViewModel {
    var cartProducts: Observable<[ItemViewModel]> = Observable([])
    var cartCount: Observable<Int> = Observable(0)
    var likedProducts: Observable<[ItemViewModel]> = Observable([])
    var lists: Observable<[List]> = Observable([])
    
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
    
}

// MARK: Cart Methods
extension ProductsViewModel {
    func addProduct(product: ItemViewModel) {
        guard let products = cartProducts.value else {
            return
        }
        
        guard products.contains(product) else {
            cartProducts.value?.insert(product, at: 0)
            increaseProduct(at: 0)
            return
        }
        
        if let index = products.firstIndex(of: product) {
            increaseProduct(at: index)
        }
        
    }
    
    func removeProduct(product: ItemViewModel) {
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
    
    func contains(product: ItemViewModel) -> Bool {
        guard let products = cartProducts.value, products.contains(product) else {
            return false
        }
        
        return true
    }
    
    func clearCart() {
        cartProducts.value?.removeAll()
        
        updateCount()
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

// MARK: Wish list Methods
extension ProductsViewModel {
    func likeProduct(product: ItemViewModel) {
        guard let products = likedProducts.value else {
            return
        }
        
        guard !products.contains(product) else {
            unlikeProduct(product: product)
            return
        }
        
        likedProducts.value?.insert(product, at: 0)
    }
    
    private func unlikeProduct(product: ItemViewModel) {
        guard let index = likedProducts.value?.firstIndex(of: product) else {
            return
        }
        likedProducts.value?.remove(at: index)
    }
    
    func isLiked(product: ItemViewModel) -> Bool {
        guard let products = likedProducts.value, products.contains(product) else {
            return false
        }
        
        return true
    }
}
