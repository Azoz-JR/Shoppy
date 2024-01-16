//
//  WishListViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 10/01/2024.
//

import Foundation
import RxSwift
import RxRelay

class WishListViewModel {    
    var wishListRelay = BehaviorRelay<List>(value: List(id: UUID().uuidString, name: "Wish List", items: [], date: Date()))
    var wishList: Observable<List> {
        return wishListRelay.asObservable()
    }
    
    func getWishList(userId: String, completion: (@escaping () -> Void) = {}) {
        Task {
            do {
                let wishList = try await UserManager.shared.getUserWishList(userId: userId)
                await MainActor.run {
                    wishListRelay.accept(wishList)
                    completion()
                }
                
            } catch {
                print("ERROR CREATING List")
            }
        }
    }

    
    func likeProduct(product: ItemModel) {
        guard !isLiked(product: product) else {
            unlikeProduct(product: product)
            return
        }
        
        Task {
            var wishList = wishListRelay.value
            wishList.add(item: product)
            
            do {
                try await UserManager.shared.updateUserWishList(userId: "9Cvmx2WJsVBARTmaQy6Q", list: wishList)
                
                getWishList(userId: "9Cvmx2WJsVBARTmaQy6Q")
            } catch {
                
            }
        }
    }
    
    private func unlikeProduct(product: ItemModel) {
        Task {
            var wishList = wishListRelay.value
            wishList.remove(item: product)
            
            do {
                try await UserManager.shared.updateUserWishList(userId: "9Cvmx2WJsVBARTmaQy6Q", list: wishList)
                
                getWishList(userId: "9Cvmx2WJsVBARTmaQy6Q")
            } catch {
                
            }
        }
    }
    
    func isLiked(product: ItemModel) -> Bool {
        guard wishListRelay.value.contains(item: product) else {
            return false
        }
        
        return true
    }
    
}
