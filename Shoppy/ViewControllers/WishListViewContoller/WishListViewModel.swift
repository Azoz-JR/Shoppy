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
    
    var currentUserId: String {
        let uid = try? AuthenticationManager.shared.getAuthenticatedUser().uid
        return uid ?? ""
    }
    
    init() {
        getWishList()
    }
    
    
    func getWishList(completion: ((Error?) -> Void)? = nil) {
        Task {
            do {
                let wishList = try await UserManager.shared.getUserWishList(userId: currentUserId)
                await MainActor.run {
                    wishListRelay.accept(wishList)
                    completion?(nil)
                }
                
            } catch {
                completion?(error)
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
                try await UserManager.shared.updateUserWishList(userId: currentUserId, list: wishList)
                
                getWishList()
            } catch {
                
            }
        }
    }
    
    private func unlikeProduct(product: ItemModel) {
        Task {
            var wishList = wishListRelay.value
            wishList.remove(item: product)
            
            do {
                try await UserManager.shared.updateUserWishList(userId: currentUserId, list: wishList)
                
                getWishList()
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
