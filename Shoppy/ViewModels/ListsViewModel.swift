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
    
    func getLists(userId: String) {
        Task {
            do {
                let lists = try await UserManager.shared.getAllUserLists(userId: userId)
                await MainActor.run {
                    listsRelay.accept(lists)
                }
            } catch {
                print("ERROR CREATING List")
            }
        }
    }
    
    func createList(name: String, completion: @escaping (String) -> Void) {
        guard !contains(name: name) else {
            completion("\(name) list already exists. Try another name")
            return
        }
        
        Task {
            do {
                try await UserManager.shared.addUserList(userId: "9Cvmx2WJsVBARTmaQy6Q", name: name)
                completion("\(name) cretaed successfully")
                getLists(userId: "9Cvmx2WJsVBARTmaQy6Q")
            } catch {
                print("ERROR CREATING List")
            }
        }
    }
    
    func delete(list: List) {
        Task {
            do {
                try await UserManager.shared.removeUserList(userId: "9Cvmx2WJsVBARTmaQy6Q", listId: list.id)
                
                getLists(userId: "9Cvmx2WJsVBARTmaQy6Q")
            } catch {
                print("ERROR DELETING List")
            }
        }
    }
    
    func add(item: ItemViewModel, at index: Int) {
        Task {
            var list = self.listsRelay.value[index]
            list.add(item: item)
            
            do {
                try await UserManager.shared.updateUserList(userId: "9Cvmx2WJsVBARTmaQy6Q", list: list)
                
                getLists(userId: "9Cvmx2WJsVBARTmaQy6Q")
            } catch {
                
            }
        }
        
    }
    
    func remove(item: ItemViewModel, at list: List) {
        
        Task {
            var tempList = list
            tempList.remove(item: item)
            
            do {
                try await UserManager.shared.updateUserList(userId: "9Cvmx2WJsVBARTmaQy6Q", list: tempList)
                print(list.name)
                print(list.id)
                
                getLists(userId: "9Cvmx2WJsVBARTmaQy6Q")
            } catch {
                
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
