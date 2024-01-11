//
//  CollectionsAPI.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import Foundation

class CollectionsAPI {
    static let shared = CollectionsAPI()
    
    private init() { }
    
    func loadCollections() async throws -> [SmartCollection] {
        guard let url = URL(string: Constants.smartCollections) else {
            throw URLError(.badURL)
        }
        
        do {
            let products = try await loadData(url: url)
            return products
            
        } catch {
            throw error
        }
        
    }
    
    private func loadData(url: URL) async throws -> [SmartCollection] {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            let products = try handleResults(data: data, response: response)
            return products
            
        } catch {
            throw error
        }
    }
    
    private func handleResults(data: Data, response: URLResponse) throws -> [SmartCollection] {
        guard let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let results = try decoder.decode(Collections.self, from: data)
            let collections = results.smartCollections
            return collections
        } catch {
            print("ERROR DOWNLOADING PRODUCTS: \(error.localizedDescription)")
            throw error
        }
    }
    
//    func loadCollections(completion: @escaping (Result<[SmartCollection], Error>) -> Void) {
//        guard let url = URL(string: Constants.smartCollections) else {
//            return completion(.failure(URLError(.badURL)))
//        }
//        loadData(url: url) { result in
//            completion(result)
//        }
//    }
    
//    func loadData(url: URL, completion: @escaping (Result<[SmartCollection], Error>) -> Void ) {
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
//            if let result = self?.handleResults(data: data, response: response, error: error) {
//                completion(result)
//            }
//        }
//        task.resume()
//    }
    
//    func handleResults(data: Data?, response: URLResponse?, error: Error?) -> Result<[SmartCollection], Error> {
//        if let error = error {
//            return .failure(error)
//        }
//        
//        guard
//            let data = data,
//            let response = response as? HTTPURLResponse,
//            response.statusCode >= 200 && response.statusCode < 300 else {
//            return .failure(URLError(.badServerResponse))
//        }
//        
//        do {
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
//            let results = try decoder.decode(Collections.self, from: data)
//            let collections = results.smartCollections
//            return .success(collections)
//        } catch {
//            print("ERROR DOWNLOADING Collections: \(error.localizedDescription)")
//            return .failure(error)
//        }
//        
//    }
    
}
