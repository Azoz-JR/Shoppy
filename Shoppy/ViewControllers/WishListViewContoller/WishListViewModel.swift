//
//  WishListViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 10/01/2024.
//

import Foundation

class WishListViewModel {
    var wishList: Observable<List> = Observable(List(name: "Wish List", items: []))

    
    func likeProduct(product: ItemViewModel) {
        guard !isLiked(product: product) else {
            unlikeProduct(product: product)
            return
        }
        
        wishList.value?.add(item: product)
    }
    
    private func unlikeProduct(product: ItemViewModel) {
        wishList.value?.remove(item: product)
    }
    
    func isLiked(product: ItemViewModel) -> Bool {
        guard let list = wishList.value, list.contains(item: product) else {
            return false
        }
        
        return true
    }
    
}
