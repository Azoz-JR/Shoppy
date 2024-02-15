//
//  ProductsAPI.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import Foundation

final class ProductsAPI {
    static let shared = ProductsAPI()
    
    private init() {}
    
    
    
    func loadProducts() async throws -> [Product] {
        guard let url = URL(string: Constants.allProductsURL) else {
            throw URLError(.badURL)
        }
        
        do {
            let products = try await loadData(url: url)
            return products
            
        } catch {
            throw error
        }
        
    }
    
    func loadCategoryProducts(category: String) async throws -> [Product] {
        guard let url = URL(string: Constants.collection + category) else {
            throw URLError(.badURL)
        }
        
        do {
            let products = try await loadData(url: url)
            return products
            
        } catch {
            throw error
        }
        
    }
    
    private func loadData(url: URL) async throws -> [Product] {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            let products = try handleResults(data: data, response: response)
            return products
            
        } catch {
            throw error
        }
    }
    
    private func handleResults(data: Data, response: URLResponse) throws -> [Product] {
        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let results = try decoder.decode(Products.self, from: data)
            let products = results.products
            return products
        } catch {
            throw error
        }
    }
}
