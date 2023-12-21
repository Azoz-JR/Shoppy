//
//  ProductsAPI.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import Foundation

class ProductsAPI {
    static let shared = ProductsAPI()
    
    private init() {}
    
    func loadProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: Constants.allProductsURL) else {
            return completion(.failure(URLError(.badURL)))
        }
        loadData(url: url) { result in
            completion(result)
        }
    }
    
    func loadCategoryProducts(category: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: Constants.collection + category) else {
            return completion(.failure(URLError(.badURL)))
        }
        
        loadData(url: url) { result in
            completion(result)
        }
    }
    
    func loadData(url: URL, completion: @escaping (Result<[Product], Error>) -> Void ) {
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            if let result = self?.handleResults(data: data, response: response, error: error) {
                completion(result)
            }
        }
        task.resume()
    }
    
    func handleResults(data: Data?, response: URLResponse?, error: Error?) -> Result<[Product], Error> {
        if let error = error {
            return .failure(error)
        }
        
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return .failure(URLError(.badServerResponse))
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let results = try decoder.decode(Products.self, from: data)
            let products = results.products
            return .success(products)
        } catch {
            print("ERROR DOWNLOADING PRODUCTS: \(error.localizedDescription)")
            return .failure(error)
        }
        
    }
    
}
