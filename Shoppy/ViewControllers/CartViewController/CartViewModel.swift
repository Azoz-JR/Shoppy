//
//  CartViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 10/01/2024.
//

import Foundation
import RxSwift
import RxRelay


class CartViewModel {
    private let cartProductsRelay = BehaviorRelay<[ItemModel]>(value: [])
    var cartProducts: Observable<[ItemModel]> {
        cartProductsRelay.asObservable()
    }
    
    private let errorSubject = PublishSubject<Error>()
    var error: Observable<Error> {
        errorSubject.asObservable()
    }
    
    private let checkoutDoneSubject = PublishSubject<Bool>()
    var checkoutDone: Observable<Bool> {
        checkoutDoneSubject.asObservable()
    }
    
    var cartCount: MyObservable<Int> = MyObservable(0)
    var selectedAddress: Address?
    
    private var ordersRelay = BehaviorRelay<[Order]>(value: [])
    var orders: Observable<[Order]> {
        ordersRelay.asObservable()
    }
    
    var currentUserId: String {
        let uid = try? AuthenticationManager.shared.getAuthenticatedUser().uid
        return uid ?? ""
    }
    
    var couponText: String = ""
    var isPromoCodeApplied = false
    
    var subTotal: Double {
        guard !cartProductsRelay.value.isEmpty else {
            return 0.0
        }
        
        var total = 0.0
        cartProductsRelay.value.forEach { product in
            total += product.price * Double(product.count)
        }
        
        return total
    }
    
    var total: Double {
        return subTotal * (1 - discountPercentage)
    }
    
    var discount: Double {
        return subTotal * discountPercentage
    }
    
    var discountPercentage: Double {
        if isPromoCodeApplied {
            return PromoCode(rawValue: couponText)?.value ?? 0.0
        } else {
            return 0.0
        }
    }
    
    var promoCode: String? {
        if isPromoCodeApplied {
            return couponText
        } else {
            return nil
        }
    }
    
    func getCart(completion: (() -> Void)? = nil) {
        Task {
            do {
                let cart = try await UserManager.shared.getUserCart(userId: currentUserId)
                
                await MainActor.run {
                    cartProductsRelay.accept(cart)
                    updateCount()
                    completion?()
                }
                
            } catch {
                errorSubject.onNext(error)
            }
        }
    }
    
    func applyPromoCode(code: String, completion: @escaping (PromoCodeError?) -> Void) async throws {
        try await PromoCodesManager.shared.applyPromoCode(code: code) { promoCode, error in
            if let error {
                // Wrong Promo code
                completion(error)
                return
            }
            
            // Applied Successfuly
            completion(nil)
        }
    }
    
    func addProduct(product: ItemModel, completion: @escaping (Error?) -> Void) {
        Task {
            let cart = self.insertProduct(product: product)
            
            do {
                try await UserManager.shared.updateUserCart(userId: currentUserId, cart: cart)
                
                getCart()
                
                await MainActor.run {
                    completion(nil)
                }
            } catch {
                await MainActor.run {
                    completion(error)
                }
            }
        }
        
    }
    
    private func insertProduct(product: ItemModel) -> [ItemModel] {
        var cart = self.cartProductsRelay.value
        
        if !cart.contains(product) {
            cart.insert(product, at: 0)
            cart[0].increaseCount()
        } else {
            if let index = cart.firstIndex(of: product) {
                cart[index].increaseCount()
            }
        }
        
        return cart
    }
    
    func decreaseProduct(product: ItemModel, completion: @escaping (Error?) -> Void) {
        Task {
            let cart = self.removeProduct(product: product)
            
            do {
                try await UserManager.shared.updateUserCart(userId: currentUserId, cart: cart)
                
                getCart()
                
                await MainActor.run {
                    completion(nil)
                }
            } catch {
                await MainActor.run {
                    completion(error)
                }
            }
        }
    }
    
    private func removeProduct(product: ItemModel) -> [ItemModel] {
        var cart = self.cartProductsRelay.value
        
        if let index =  cart.firstIndex(of: product) {
            
            if cart[index].count > 1 {
                cart[index].decreaseCount()
            } else {
                cart.remove(at: index)
            }
        }
        
        return cart
    }
    
    func removeProduct(at index: Int) {
        Task {
            var cart = self.cartProductsRelay.value
            cart.remove(at: index)
            
            do {
                try await UserManager.shared.updateUserCart(userId: currentUserId, cart: cart)
                
                getCart()
            } catch {
                
            }
        }
    }
    
    func clearCart() {
        Task {
            do {
                try await UserManager.shared.updateUserCart(userId: currentUserId, cart: [])
                
                getCart()
                
                await MainActor.run {
                    isPromoCodeApplied = false
                    couponText = ""
                }
            } catch {
                errorSubject.onNext(error)
            }
        }
    }
    
    func updateCount() {
        var count = 0
        
        cartProductsRelay.value.forEach { item in
            count += item.count
        }
        cartCount.value = count
    }
}


// MARK: - Orders Methods
extension CartViewModel {
    func getOrders() async throws {
        let orders = try await UserManager.shared.getAllUserOrders(userId: currentUserId)
        
        await MainActor.run {
            ordersRelay.accept(orders)
        }
    }
    
    func placeOrder() async throws {
        guard let selectedAddress else {
            return
        }
        
        let order = Order(id: UUID().uuidString, items: cartProductsRelay.value, total: total, subTotal: subTotal, discount: discount, promoCode: promoCode, date: Date.now, address: selectedAddress)
        
        try await UserManager.shared.addUserOrder(userId: currentUserId, order: order)
        
        checkoutDoneSubject.onNext(true)
        
        try await getOrders()
    }
    
}
