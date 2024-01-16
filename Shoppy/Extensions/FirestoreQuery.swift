//
//  FirestoreQuery.swift
//  Shoppy
//
//  Created by Azoz Salah on 15/01/2024.
//

import Foundation
import FirebaseFirestore

extension Query {
    
    func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        try await getDocumentsWithSnapshot(as: type).products
    }
    
    func getDocumentsWithSnapshot<T: Decodable>(as type: T.Type) async throws -> (products: [T], lastDocumnet: DocumentSnapshot?) {
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
                
        return (products, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else {
            return self
        }
        
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
}
