//
//  DBUser.swift
//  Shoppy
//
//  Created by Azoz Salah on 29/01/2024.
//

import UIKit

struct DBUser: Codable{
    let userId: String
    let firstName: String?
    let lastName: String?
    let email: String?
    let dateCreated: Date?
    let profilePicture: Data?
    
    init(userId: String, firstName: String?, lastName: String?, email: String? = nil, dateCreated: Date? = nil, profilePicture: Data? = nil) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.dateCreated = dateCreated
        self.profilePicture = profilePicture
    }
    
    init(auth: AuthDataResultModel, firstName: String? = nil, lastName: String? = nil) {
        self.userId = auth.uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = auth.email
        self.dateCreated = Date()
        self.profilePicture = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case dateCreated = "date_created"
        case profilePicture = "profile_picture"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.profilePicture = try container.decodeIfPresent(Data.self, forKey: .profilePicture)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.lastName, forKey: .lastName)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.profilePicture, forKey: .profilePicture)
    }
    
    var profileImage: UIImage? {
        guard let data = profilePicture else {
            return nil
        }
        
        return UIImage(data: data)
    }
    
    var fullName: String? {
        guard let firstName else {
            return nil
        }
        
        guard let lastName else {
            return firstName
        }
        
        return (firstName + " " + lastName)
    }
    
}

struct UserWishList: Codable {
    var list: List = List(id: UUID().uuidString, name: "Wish list", items: [], date: Date())
}

struct UserCart: Codable {
    var cart: [ItemModel] = []
}

