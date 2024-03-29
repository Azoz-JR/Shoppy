//
//  HomeViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 10/01/2024.
//

import Foundation
import RxSwift


class HomeViewModel {
    var sections: [Section] = []
    var service: Service = ProductsAPIServiceAdapter(api: ProductsAPI.shared)
    
    private var productsSubject = PublishSubject<[ItemModel]>()
    private let errorSubject = PublishSubject<Error>()
        
    var productsObservable: Observable<[ItemModel]> {
        return productsSubject.asObservable()
    }
    
    var error: Observable<Error> {
        errorSubject.asObservable()
    }
    
    
    func load() async {
        do {            
            let products = try await service.loadProducts()
                        
            await MainActor.run {
                
                self.sections = [
                    Section(title: "Categories", items: []),
                    Section(title: "SALES", items: []),
                    Section(title: "Recomended for you", items: products.filter({$0.vendor == "ADIDAS"})),
                    Section(title: "Most popular", items: products.filter({$0.vendor == "NIKE"})),
                    Section(title: "Shoes", items: products.filter({$0.category == .shoes})),
                    Section(title: "Accessories", items: products.filter({$0.category == .accessories})),
                    Section(title: "T-Shirts", items: products.filter({$0.category == .tShirts}))
                ]
                
                self.productsSubject.onNext(products)
            }
            
        } catch {
            await MainActor.run {
                errorSubject.onNext(error)
            }
        }
    }
    
}
