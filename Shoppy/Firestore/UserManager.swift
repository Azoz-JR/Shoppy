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
        let document = userOrdersCollection(userId: userId).document(order.id)
        
        try document.setData(from: order, merge: false)
        
        // If the user used a promo code add it
        if let promoCode = PromoCode(rawValue: order.promoCode ?? "")  {
            try await updateUsedPromoCodes(userId: userId, codes: [promoCode.rawValue: promoCode.value])
        }
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
        let updatedList = UserWishList(list: list)
        
        try userWishListDocument(userId: userId).setData(from: updatedList)
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
        let list = List(id: UUID().uuidString, name: name, items: [], date: Date())
        let document = userListsCollection(userId: userId).document(list.id)
        
        try document.setData(from: list, merge: false)
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

// MARK: - Promo Codes
extension UserManager {
    
    private func userUsedPromoCodes(userId: String) -> DocumentReference {
        userDocument(userId: userId).collection("used_promo_codes").document("promos")
    }
    
    private func addUserPromoCode(userId: String, codes: [String: Double]) async throws {
        let data: [String: Any] = [
            "promos": FieldValue.arrayUnion([codes])
        ]
        
        try await userUsedPromoCodes(userId: userId).setData(data, merge: false)
    }
    
    private func updateUsedPromoCodes(userId: String, codes: [String: Double]) async throws {
        let data: [String: Any] = [
            "promos": FieldValue.arrayUnion([codes])
        ]
        
        try await userUsedPromoCodes(userId: userId).updateData(data)
    }
    
    func checkPromoCode(userId: String, code: PromoCode) async throws -> Bool {
        guard let usedPromos = try? await userUsedPromoCodes(userId: userId).getDocument(as: WinterSales.self).promos else {
            // User hasn't used any promo codes before
            let usedPromos: [String: Double] = [code.rawValue: code.value]
            try await addUserPromoCode(userId: userId, codes: usedPromos)
            
            return true
        }
        
        // Check if the promo code already used before
        if let _ = usedPromos[code.rawValue] {
            // Promo code already used before
            return false
        } else {
            // Promo code isn't used before
            return true
        }
    }
}
