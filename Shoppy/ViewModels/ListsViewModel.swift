//
//  ListsViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 28/12/2023.
//

import Foundation

final class ListsViewModel {
    var lists: Observable<[List]> = Observable([])
    
    func createList(list: List) {
        guard !contains(list: list) else {
            return
        }
        lists.value?.append(list)
    }
    
    func delete(list: List) {
        if let index = lists.value?.firstIndex(of: list) {
            lists.value?.remove(at: index)
        }
    }
    
    func add(item: ItemViewModel, at index: Int) {
        lists.value?[index].add(item: item)
    }
    
    func remove(item: ItemViewModel, at index: Int) {
        lists.value?[index].remove(item: item)
    }
    
    private func contains(list: List) -> Bool {
        guard let lists = lists.value, lists.contains(where: { $0 == list }) else {
            return false
        }
        return true
    }
    
}
