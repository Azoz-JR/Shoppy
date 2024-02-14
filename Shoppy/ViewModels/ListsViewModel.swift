//
//  ListsViewModel.swift
//  Shoppy
//
//  Created by Azoz Salah on 28/12/2023.
//

import Foundation
import RxSwift
import RxRelay


final class ListsViewModel {
    private var listsRelay = BehaviorRelay<[List]>(value: [])
    var lists: Observable<[List]> {
        listsRelay.asObservable()
    }
    
    var currentUserId: String {
        let uid =  try? AuthenticationManager.shared.getAuthenticatedUser().uid
        return uid ?? ""
    }
    
    
    func getLists() async throws {
        let lists = try await UserManager.shared.getAllUserLists(userId: currentUserId)
        
        await MainActor.run {
            listsRelay.accept(lists)
        }
        
    }

    func createList(name: String, completion: @escaping (String) -> Void) {
        guard !contains(name: name) else {
            completion("\(name) list already exists. Try another name")
            return
        }
        
        Task {
            do {
                try await UserManager.shared.addUserList(userId: currentUserId, name: name)
                completion("\(name) cretaed successfully")
                
                try await getLists()
            } catch {
                print("ERROR CREATING List")
            }
        }
    }
    
    func delete(list: List) {
        Task {
            do {
                try await UserManager.shared.removeUserList(userId: currentUserId, listId: list.id)
                
                try await getLists()
            } catch {
                print("ERROR DELETING List: \(error.localizedDescription)")
            }
        }
    }
    
    func add(item: ItemModel, at index: Int) {
        Task {
            var list = self.listsRelay.value[index]
            list.add(item: item)
            
            do {
                try await UserManager.shared.updateUserList(userId: currentUserId, list: list)
                
                try await getLists()
            } catch {
                print("ERROR Adding an item to a list \(error.localizedDescription)")
            }
        }
        
    }
    
    func remove(item: ItemModel, at list: List) {
        Task {
            var tempList = list
            tempList.remove(item: item)
            
            do {
                try await UserManager.shared.updateUserList(userId: currentUserId, list: tempList)
                print(list.name)
                print(list.id)
                
                try await getLists()
            } catch {
                print("ERROR removing an item from a list \(error.localizedDescription)")
            }
        }
    }
    
    private func contains(name: String) -> Bool {
        guard listsRelay.value.contains(where: { $0.name == name }) else {
            return false
        }
        return true
    }
    
}
