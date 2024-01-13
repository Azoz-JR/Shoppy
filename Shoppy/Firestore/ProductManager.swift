//
//  ProductManager.swift
//  FireBaseBootCamp
//
//  Created by Azoz Salah on 14/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


//final class ProductManager {
//    
//    static let shared = ProductManager()
//    
//    private init() {}
//    
//    private let productsCollection = Firestore.firestore().collection("products")
//    
//    private func productDocument(productId: String) -> DocumentReference {
//        productsCollection.document(productId)
//    }
//    
//    func getProduct(productId: String) async throws -> Product {
//        try await productDocument(productId: productId).getDocument(as: Product.self)
//    }
//    
//    func uploadProduct(product: Product) throws {
//        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
//    }
//    
////    private func getAllProducts() async throws -> [Product] {
////        try await productsCollection
////            .getDocuments(as: Product.self)
////
////    }
////
////    private func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product] {
////        try await productsCollection
////            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
////            .getDocuments(as: Product.self)
////    }
////
////    private func getAllProductsForCategory(category: String) async throws -> [Product] {
////        try await productsCollection
////            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
////            .getDocuments(as: Product.self)
////    }
////
////    private func getAllProductsByPriceAndCategory(descending: Bool, category: String) async throws -> [Product] {
////        try await productsCollection
////            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
////            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
////            .getDocuments(as: Product.self)
////    }
//    
//    private func getAllProductsQuery() -> Query {
//        productsCollection
//    }
//    
//    private func getAllProductsSortedByPriceQuery(descending: Bool) -> Query {
//        productsCollection
//            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
//    }
//    
//    private func getAllProductsForCategoryQuery(category: String) -> Query {
//        productsCollection
//            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
//    }
//    
//    private func getAllProductsByPriceAndCategoryQuery(descending: Bool, category: String) -> Query {
//        productsCollection
//            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
//            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
//    }
//    
//    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocumnet: DocumentSnapshot?) {
//        var query: Query = getAllProductsQuery()
//        
//        if let descending, let category {
//            query = getAllProductsByPriceAndCategoryQuery(descending: descending, category: category)
//        } else if let descending {
//            query = getAllProductsSortedByPriceQuery(descending: descending)
//        } else if let category {
//            query = getAllProductsForCategoryQuery(category: category)
//        }
//        
//        return try await query
//            .limit(to: count)
//            .startOptionally(afterDocument: lastDocument)
//            .getDocumentsWithSnapshot(as: Product.self)
//        
//    }
//    
//    func getProductsByRating(count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocumnet: DocumentSnapshot?) {
//            return try await productsCollection
//                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
//                .limit(to: count)
//                .startOptionally(afterDocument: lastDocument)
//                .getDocumentsWithSnapshot(as: Product.self)
//    }
//    
//    func getAllProductsCount() async throws -> Int {
//        try await productsCollection.aggregateCount()
//    }
//}
//
//
//extension Query {
//    
//    func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
//        try await getDocumentsWithSnapshot(as: type).products
//    }
//    
//    func getDocumentsWithSnapshot<T: Decodable>(as type: T.Type) async throws -> (products: [T], lastDocumnet: DocumentSnapshot?) {
//        let snapshot = try await self.getDocuments()
//        
//        let products = try snapshot.documents.map({ document in
//            try document.data(as: T.self)
//        })
//                
//        return (products, snapshot.documents.last)
//    }
//    
//    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
//        guard let lastDocument else {
//            return self
//        }
//        
//        return self.start(afterDocument: lastDocument)
//    }
//    
//    func aggregateCount() async throws -> Int {
//        let snapshot = try await self.count.getAggregation(source: .server)
//        return Int(truncating: snapshot.count)
//    }
//}
