//
//  List.swift
//  Shoppy
//
//  Created by Azoz Salah on 27/12/2023.
//

import Foundation

struct List: Equatable, Codable {
    let id: String
    var name: String
    var items: [ItemModel]
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case items
        case date
    }
    
    mutating func add(item: ItemModel) {
        guard !contains(item: item) else {
            return
        }
        items.insert(item, at: 0)
    }
    
    mutating func remove(item: ItemModel) {
        guard contains(item: item) else {
            return
        }
        
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
    
    func contains(item: ItemModel) -> Bool {
        guard items.contains(item) else {
            return false
        }
        return true
    }
    
    static func ==(lhs: List, rhs: List) -> Bool {
        lhs.id == rhs.id
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id" : id,
            "name" : name,
            "items" : items.map{ $0.toDictionary() },
            "date" : date
        ]
    }
    
}
