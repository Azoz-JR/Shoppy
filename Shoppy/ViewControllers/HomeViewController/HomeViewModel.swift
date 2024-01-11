//
//  HomeViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 10/01/2024.
//

import Foundation

class HomeViewModel {
    var service: Service = ProductsAPIServiceAdapter(api: ProductsAPI.shared)
    var sections: Observable<[Section]> = Observable([])
    var products: Observable<[ItemViewModel]> = Observable([])
    var error: Observable<Error> = Observable(nil)
    
    
    func load() async {
        do {
            let products = try await service.loadProducts()
            
            await MainActor.run {
                self.products.value = products
                
                self.sections.value = [
                    Section(title: "Recomended for you", items: products.filter({$0.vendor == "ADIDAS"})),
                    Section(title: "Most popular", items: products.filter({$0.vendor == "NIKE"})),
                    Section(title: "Shoes", items: products.filter({$0.category == .shoes})),
                    Section(title: "Accessories", items: products.filter({$0.category == .accessories})),
                    Section(title: "T-Shirts", items: products.filter({$0.category == .tShirts}))
                ]
            }
            
        } catch {
            await MainActor.run {
                self.error.value = error
            }
            print(error.localizedDescription)
        }
    }
    
}
