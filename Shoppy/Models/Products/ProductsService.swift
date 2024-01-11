//
//  ProductsService.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import Foundation

protocol Service {
    func loadProducts() async throws -> [ItemViewModel]
}
