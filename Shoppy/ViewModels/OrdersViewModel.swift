//
//  OrdersViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 27/12/2023.
//

import Foundation

final class OrdersViewModel {
    var orders: MyObservable<[Order]> = MyObservable([])

    func addOrder(order: Order) {
        orders.value?.insert(order, at: 0)
    }
    
    func removeOrder(order: Order) {
        if let index = orders.value?.firstIndex(where: { $0 == order }) {
            orders.value?.remove(at: index)
        }
    }
    
    func placeOrder(order: Order, completion: @escaping (Order?) -> Void) {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.uploadTask(with: request, from: encoded) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                print("Checkout failed")
                return
            }
            guard let data = data else {
                return
            }
            
            let decodedOrder = try? JSONDecoder().decode(Order.self, from: data)
            
            guard let order = decodedOrder else {
                return
            }
            
            self.addOrder(order: order)
            
            DispatchQueue.mainAsyncIfNeeded {
                completion(decodedOrder)
            }
        }
        
        task.resume()
    }
}
