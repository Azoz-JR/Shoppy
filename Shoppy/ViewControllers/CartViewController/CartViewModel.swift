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
    var cartProductsRelay = BehaviorRelay<[ItemViewModel]>(value: [])
    var cartProducts: Observable<[ItemViewModel]> {
        cartProductsRelay.asObservable()
    }
    
    var cartCount: MyObservable<Int> = MyObservable(0)
    
    private var ordersRelay = BehaviorRelay<[Order]>(value: [])
    var orders: Observable<[Order]> {
        ordersRelay.asObservable()
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
    
    func getCart(userId: String, completion: (@escaping () -> Void) = {}) {
        Task {
            do {
                let cart = try await UserManager.shared.getUserCart(userId: userId)                
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
    
    func addProduct(product: ItemViewModel) {
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
                try await UserManager.shared.updateUserCart(userId: "9Cvmx2WJsVBARTmaQy6Q", cart: cart)
                
                getCart(userId: "9Cvmx2WJsVBARTmaQy6Q")
            } catch {
                
            }
        }
        
    }
    
    func decreaseProduct(product: ItemViewModel) {
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
                try await UserManager.shared.updateUserCart(userId: "9Cvmx2WJsVBARTmaQy6Q", cart: cart)
                
                getCart(userId: "9Cvmx2WJsVBARTmaQy6Q")
            } catch {
                
            }
        }
    }
    
    func removeProduct(at index: Int) {
        Task {
            var cart = self.cartProductsRelay.value
            cart.remove(at: index)
            
            do {
                try await UserManager.shared.updateUserCart(userId: "9Cvmx2WJsVBARTmaQy6Q", cart: cart)
                
                getCart(userId: "9Cvmx2WJsVBARTmaQy6Q")
            } catch {
                
            }
        }
    }
    
    func clearCart() {
        Task {
            do {
                try await UserManager.shared.updateUserCart(userId: "9Cvmx2WJsVBARTmaQy6Q", cart: [])
                
                getCart(userId: "9Cvmx2WJsVBARTmaQy6Q")
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
    func getOrders(userId: String) {
        Task {
            do {
                let orders = try await UserManager.shared.getAllUserOrders(userId: userId)
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
                try await UserManager.shared.addUserOrder(userId: "9Cvmx2WJsVBARTmaQy6Q", order: order)
                
                getOrders(userId: "9Cvmx2WJsVBARTmaQy6Q")
            } catch {
                print("ERROR CREATING List")
            }
        }
    }
    
    func removeOrder(order: Order) {
        Task {
            do {
                try await UserManager.shared.removeUserOrder(userId: "9Cvmx2WJsVBARTmaQy6Q", orderId: order.id)
                
                getOrders(userId: "9Cvmx2WJsVBARTmaQy6Q")
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
