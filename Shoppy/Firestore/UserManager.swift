//
//  UserManager.swift
//  FireBaseBootCamp
//
//  Created by Azoz Salah on 07/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Movie: Codable {
    let id: String
    let title: String
    let isPopular: Bool
}


struct DBUser: Codable{
    let userId: String
    let firstName: String?
    let lastName: String?
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let preferences: [String]?
    let wishList: List
    let cart: [ItemModel]
    
    init(userId: String, firstName: String?, lastName: String?, isAnonymous: Bool? = nil, email: String? = nil, photoUrl: String? = nil, dateCreated: Date? = nil, isPremium: Bool? = nil, preferences: [String]? = nil, wishList: List, cart: [ItemModel]) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.wishList = wishList
        self.cart = cart
    }
    
    init(auth: AuthDataResultModel, firstName: String? = nil, lastName: String? = nil) {
        self.userId = auth.uid
        self.firstName = firstName
        self.lastName = lastName
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoUrl = auth.photoURL
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.wishList = List(id: UUID().uuidString, name: "Wish list", items: [], date: Date())
        self.cart = []
    }
    
//    mutating func togglePremiumStatus() {
//        let currentValue = isPremium ?? false
//        isPremium = !currentValue
//    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "user_ispremium"
        case preferences = "preferences"
        case wishList = "wish_list"
        case cart = "cart"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.wishList = try container.decode(List.self, forKey: .wishList)
        self.cart = try container.decode([ItemModel].self, forKey: .cart)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.lastName, forKey: .lastName)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encode(self.wishList, forKey: .wishList)
        try container.encode(self.cart, forKey: .cart)
    }
    
}

final class UserManager {
    
    static let shared = UserManager()
    
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func userOrdersCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("orders")
    }
    
    private func userListsCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("lists")
    }
    
    private func userOrderDocument(userId: String, orderId: String) -> DocumentReference {
        userOrdersCollection(userId: userId).document(orderId)
    }
    
    private func userListDocument(userId: String, listId: String) -> DocumentReference {
        userListsCollection(userId: userId).document(listId)
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
    
    func updateUserWishList(userId: String, list: List) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.wishList.rawValue: list.toDictionary()
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserCart(userId: String, cart: [ItemModel]) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.cart.rawValue: cart.map { $0.toDictionary() }
        ]
        
        try await userDocument(userId: userId).updateData(data)
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
    
    func removeUserOrder(userId: String, orderId: String) async throws {
        try await userOrderDocument(userId: userId, orderId: orderId).delete()
    }
    
    func getAllUserOrders(userId: String) async throws -> [Order] {
        try await userOrdersCollection(userId: userId).getDocuments(as: Order.self)
    }
    
    func getAllUserLists(userId: String) async throws -> [List] {
        try await userListsCollection(userId: userId).getDocuments(as: List.self)
    }
    
    func getUserWishList(userId: String) async throws -> List {
        return try await getUser(userId: userId).wishList
    }
    
    func getUserCart(userId: String) async throws -> [ItemModel] {
        return try await getUser(userId: userId).cart
    }
    
}


struct UserFavoriteProduct: Codable, Identifiable {
    let id: String
    let productId: Int
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case productId = "product_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productId = try container.decode(Int.self, forKey: .productId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.productId, forKey: .productId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
    
}
