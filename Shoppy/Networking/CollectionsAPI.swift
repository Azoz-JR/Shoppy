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
    
    func loadCollections(completion: @escaping (Result<[SmartCollection], Error>) -> Void) {
        guard let url = URL(string: Constants.smartCollections) else {
            return completion(.failure(URLError(.badURL)))
        }
        loadData(url: url) { result in
            completion(result)
        }
    }
    
    func loadData(url: URL, completion: @escaping (Result<[SmartCollection], Error>) -> Void ) {
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            if let result = self?.handleResults(data: data, response: response, error: error) {
                completion(result)
            }
        }
        task.resume()
    }
    
    func handleResults(data: Data?, response: URLResponse?, error: Error?) -> Result<[SmartCollection], Error> {
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
            let results = try decoder.decode(Collections.self, from: data)
            let collections = results.smartCollections
            return .success(collections)
        } catch {
            print("ERROR DOWNLOADING Collections: \(error.localizedDescription)")
            return .failure(error)
        }
        
    }
}
