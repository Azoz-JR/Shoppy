//
//  List.swift
//  Shoppy
//
//  Created by Azoz Salah on 27/12/2023.
//

import Foundation

struct List: Equatable {
    var name: String
    var items: [ItemViewModel]
    
    mutating func add(item: ItemViewModel) {
        guard !contains(item: item) else {
            return
        }
        items.insert(item, at: 0)
    }
    
    mutating func remove(item: ItemViewModel) {
        guard contains(item: item) else {
            return
        }
        
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
    
    func contains(item: ItemViewModel) -> Bool {
        guard items.contains(item) else {
            return false
        }
        return true
    }
    
    static func ==(lhs: List, rhs: List) -> Bool {
        lhs.name == rhs.name
    }
}
