//
//  ProductsService.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import Foundation

protocol ProductsService {
    func loadProducts(completion: @escaping (Result<[Product], Error>) -> Void)
}
