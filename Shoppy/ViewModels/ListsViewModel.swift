//
//  ListsViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 28/12/2023.
//

import Foundation

final class ListsViewModel {
    var likedProducts: Observable<[ItemViewModel]> = Observable([])
    var lists: Observable<[List]> = Observable([])
    
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
