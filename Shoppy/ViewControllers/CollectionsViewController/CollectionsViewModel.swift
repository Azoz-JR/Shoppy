//
//  CollectionsViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 10/01/2024.
//

import Foundation

class CollectionsViewModel {
    var service: Service = CollectionsAPIServiceAdapter(api: CollectionsAPI.shared)
    var collections: MyObservable<[ItemModel]> = MyObservable([])
    var error: MyObservable<Error> = MyObservable(nil)
    
    
    func load() async {
        do {
            let collections = try await service.loadProducts()
            
            await MainActor.run {
                self.collections.value = collections
            }
            
        } catch {
            await MainActor.run {
                self.error.value = error
            }
            print(error.localizedDescription)
        }
    }
    
}
