//
//  WishListViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 10/01/2024.
//

import Foundation

class WishListViewModel {
    var wishList: MyObservable<List> = MyObservable(List(id: UUID().uuidString, name: "Wish List", items: [], date: Date()))
    
    func getWishList(userId: String) {
        Task {
            do {
                let wishList = try await UserManager.shared.getUserWishList(userId: userId)
                self.wishList.value = wishList
            } catch {
                print("ERROR CREATING List")
            }
        }
    }

    
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
