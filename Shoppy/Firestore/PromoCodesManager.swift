//
//  PromoCodesManager.swift
//  Shoppy
//
//  Created by Azoz Salah on 01/02/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class PromoCodesManager {
    static let shared = PromoCodesManager()
    
    private init() {}
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    private let promoCodesCollection = Firestore.firestore().collection("promo_codes")
    
    private func promoCodesDocument() -> DocumentReference {
        promoCodesCollection.document("winter_sales")
    }
    
    func applyPromoCode(code: String, completion: @escaping (PromoCode?, PromoCodeError?) -> Void) async throws {
        let promos = try await promoCodesDocument().getDocument(as: WinterSales.self).promos
        
        guard let _ = promos[code], let promoCode = PromoCode(rawValue: code) else {
            // Wrong Promo Code
            completion(nil, PromoCodeError.wrongPromoCode)
            return
        }
        
        let currentUserId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        
        // Check if the user used this promo Code before
        guard try await UserManager.shared.checkPromoCode(userId: currentUserId, code: promoCode) else {
            // Promo code used before
            completion(nil, PromoCodeError.usedPromoCode)
            return
        }
        
        // Correct + Unused Promo code
        completion(promoCode, nil)
    }
}

struct WinterSales: Codable {
    let promos: [String: Double]
}

enum PromoCode: String {
    case sales10 = "SALES10"
    case sales15 = "SALES15"
    case sales20 = "SALES20"
    
    var value: Double {
        switch self {
        case .sales10:
            0.1
        case .sales15:
            0.15
        case .sales20:
            0.2
        }
    }
}

enum PromoCodeError: Error, LocalizedError {
    case wrongPromoCode
    case usedPromoCode
    
    var errorDescription: String? {
        switch self {
        case .wrongPromoCode:
            "Incorrect Promo Code"
        case .usedPromoCode:
            "You already used this Promo Code before"
        }
    }
}
