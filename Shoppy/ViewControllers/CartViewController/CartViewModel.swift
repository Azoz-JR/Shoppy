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
    
    var currentUserId: String {
        let uid = try? AuthenticationManager.shared.getAuthenticatedUser().uid
        return uid ?? ""
    }
    
    var total: Double {
        guard !cartProductsRelay.value.isEmpty else {
            return 0.0
        }
        
        var total = 0.0
        cartProductsRelay.value.forEach { product in
            total += product.price * Double(product.count)
        }
        
        return total
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
    
    func addProduct(product: ItemModel) {
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
            } catch {
                
            }
        }
        
    }
    
    func decreaseProduct(product: ItemModel) {
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
            } catch {
                
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
    
    func addOrder(order: Order) {
        Task {
            do {
                try await UserManager.shared.addUserOrder(userId: currentUserId, order: order)
                
                getOrders()
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
    
    func placeOrder(order: Order, completion: @escaping (Order) -> Void) async throws {
        guard let url = URL(string: "https://reqres.in/api/cupcakes") else {
            print("Failed to encode order")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let encoded = try JSONEncoder().encode(order)
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            
            self.addOrder(order: order)
            
            await MainActor.run {
                completion(decodedOrder)
            }
                          
        } catch {
            print(error.localizedDescription)
            print("Checkout failed")
            throw error
        }
    }
    
}
