//
//  UserManager.swift
//  FireBaseBootCamp
//
//  Created by Azoz Salah on 07/04/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift


final class UserManager {
    
    static let shared = UserManager()
    
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
        try createUserCart(userId: user.userId)
        try createUserWishList(userId: user.userId)
    }
        
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func getCurrentUser() async -> DBUser? {
        do {
            let uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
            return try await userDocument(userId: uid).getDocument(as: DBUser.self)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func updateUserProfilePicture(userId: String, picture: Data) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.profilePicture.rawValue: picture
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
}


// MARK: - Orders
extension UserManager {
    private func userOrdersCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("orders")
    }
    
    private func userOrderDocument(userId: String, orderId: String) -> DocumentReference {
        userOrdersCollection(userId: userId).document(orderId)
    }
    
    func addUserOrder(userId: String, order: Order) async throws {
        let document = userOrdersCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String: Any] = [
            Order.CodingKeys.id.rawValue: documentId,
            Order.CodingKeys.items.rawValue: order.items.map {$0.toDictionary()},
            Order.CodingKeys.price.rawValue: order.price,
            Order.CodingKeys.date.rawValue: Timestamp()
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func removeUserOrder(userId: String, orderId: String) async throws {
        try await userOrderDocument(userId: userId, orderId: orderId).delete()
    }
    
    func getAllUserOrders(userId: String) async throws -> [Order] {
        try await userOrdersCollection(userId: userId).getDocuments(as: Order.self)
    }
}


// MARK: - Lists
extension UserManager {
    private func userListsCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("lists")
    }
    
    private func userListDocument(userId: String, listId: String) -> DocumentReference {
        userListsCollection(userId: userId).document(listId)
    }
    
    private func userWishListDocument(userId: String) -> DocumentReference {
        userDocument(userId: userId).collection("wish_list").document("items")
    }
    
    func createUserWishList(userId: String) throws {
        try userWishListDocument(userId: userId).setData(from: UserWishList(), merge: false)
    }
    
    func updateUserWishList(userId: String, list: List) async throws {
        let data: [String: Any] = [
            "list": list.toDictionary()
        ]
        
        try await userWishListDocument(userId: userId).setData(data)
    }
    
    func updateUserList(userId: String, list: List) async throws {
        let data: [String: Any] = [
            List.CodingKeys.items.rawValue: list.items.map { $0.toDictionary() }
        ]
        
        try await userListDocument(userId: userId, listId: list.id).updateData(data)
    }
    
    func updateUserListItems(userId: String, list: List, items: [ItemModel]) async throws {
        let data: [String: Any] = [
            List.CodingKeys.items.rawValue: list.items.map { $0.toDictionary() }
        ]
        
        try await userListDocument(userId: userId, listId: list.id).updateData(data)
    }
    
    func addUserList(userId: String, name: String) async throws {
        let document = userListsCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String: Any] = [
            List.CodingKeys.id.rawValue: documentId,
            List.CodingKeys.items.rawValue: [],
            List.CodingKeys.name.rawValue: name,
            List.CodingKeys.date.rawValue: Timestamp()
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func removeUserList(userId: String, listId: String) async throws {
        try await userListDocument(userId: userId, listId: listId).delete()
    }

    func getAllUserLists(userId: String) async throws -> [List] {
        try await userListsCollection(userId: userId).getDocuments(as: List.self)
    }
    
    func getUserWishList(userId: String) async throws -> List {
        return try await userWishListDocument(userId: userId).getDocument(as: UserWishList.self).list
    }
}

// MARK: - Cart
extension UserManager {
    private func userCartDocument(userId: String) -> DocumentReference {
        userDocument(userId: userId).collection("cart").document("cart")
    }
    
    func createUserCart(userId: String) throws {
        try userCartDocument(userId: userId).setData(from: UserCart(cart: []), merge: false)
    }
    
    func updateUserCart(userId: String, cart: [ItemModel]) async throws {
        let data: [String: Any] = [
            "cart": cart.map { $0.toDictionary() }
        ]
        
        try await userCartDocument(userId: userId).setData(data)
    }
    
    func getUserCart(userId: String) async throws -> [ItemModel] {
        return try await userCartDocument(userId: userId).getDocument(as: UserCart.self).cart
    }
}
