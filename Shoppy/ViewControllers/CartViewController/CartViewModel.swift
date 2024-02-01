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
    var cartProductsRelay = BehaviorRelay<[ItemModel]>(value: [])
    var cartProducts: Observable<[ItemModel]> {
        cartProductsRelay.asObservable()
    }
    
    var cartCount: MyObservable<Int> = MyObservable(0)
    
    private var ordersRelay = BehaviorRelay<[Order]>(value: [])
    var orders: Observable<[Order]> {
        ordersRelay.asObservable()
    }
    
    var discountPercentage = 0.0
    
    var currentUserId: String {
        let uid = try? AuthenticationManager.shared.getAuthenticatedUser().uid
        return uid ?? ""
    }
    
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
    
    func getCart(completion: (@escaping () -> Void) = {}) {
        Task {
            do {
                let cart = try await UserManager.shared.getUserCart(userId: currentUserId)
                await MainActor.run {
                    cartProductsRelay.accept(cart)
                    updateCount()
                    completion()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func applyPromoCode(code: String, completion: @escaping (PromoCodeError?) -> Void) async throws {
        try await PromoCodesManager.shared.applyPromoCode(code: code) { [weak self] promoCode, error in
            if let error {
                // Wrong Promo code
                completion(error)
                return
            }
            
            self?.discountPercentage = promoCode?.value ?? 0.0
            completion(nil)
        }
    }
    
    func addProduct(product: ItemModel, completion: @escaping () -> Void) {
        Task {
            var cart = self.cartProductsRelay.value
            
            if !cart.contains(product) {
                cart.insert(product, at: 0)
                cart[0].increaseCount()
            } else {
                if let index = cart.firstIndex(of: product) {
                    cart[index].increaseCount()
                }
            }
            
            do {
                try await UserManager.shared.updateUserCart(userId: currentUserId, cart: cart)
                
                getCart()
                
                await MainActor.run {
                    completion()
                }
            } catch {
                print(error.localizedDescription)
                await MainActor.run {
                    completion()
                }
            }
        }
        
    }
    
    func decreaseProduct(product: ItemModel, completion: @escaping () -> Void) {
        Task {
            var cart = self.cartProductsRelay.value
            
            if let index =  cart.firstIndex(of: product) {
                
                if cart[index].count > 1 {
                    cart[index].decreaseCount()
                } else {
                    cart.remove(at: index)
                }
            }
            
            do {
                try await UserManager.shared.updateUserCart(userId: currentUserId, cart: cart)
                
                getCart()
                
                await MainActor.run {
                    completion()
                }
            } catch {
                print(error.localizedDescription)
                await MainActor.run {
                    completion()
                }
            }
        }
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
            } catch {
                
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
    func getOrders() {
        Task {
            do {
                let orders = try await UserManager.shared.getAllUserOrders(userId: currentUserId)
                await MainActor.run {
                    ordersRelay.accept(orders)
                }
            } catch {
                print("ERROR CREATING List")
            }
        }
    }
    
    func removeOrder(order: Order) {
        Task {
            do {
                try await UserManager.shared.removeUserOrder(userId: currentUserId, orderId: order.id)
                
                getOrders()
            } catch {
                print("ERROR CREATING List")
            }
        }
    }
    
    func placeOrder(completion: @escaping () -> Void) async throws {
        let order = Order(id: UUID().uuidString, items: cartProductsRelay.value, price: subTotal, date: Date.now)
        
        Task {
            try await UserManager.shared.addUserOrder(userId: currentUserId, order: order)
            
            getOrders()
        }
                
        await MainActor.run {
            completion()
        }
    }
    
//    func placeOrder(order: Order, completion: @escaping (Order) -> Void) async throws {
//        guard let url = URL(string: "https://reqres.in/api/cupcakes") else {
//            print("Failed to encode order")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        
//        do {
//            let encoded = try JSONEncoder().encode(order)
//            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
//            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
//            
//            self.addOrder(order: order)
//            
//            await MainActor.run {
//                completion(decodedOrder)
//            }
//                          
//        } catch {
//            print(error.localizedDescription)
//            throw error
//        }
//    }
    
}
