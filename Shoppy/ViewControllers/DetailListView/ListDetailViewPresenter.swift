//
//  ListDetailViewPresenter.swift
//  Shoppy
//
//  Created by Azoz Salah on 05/01/2024.
//

import Foundation

protocol ListDetailViewPresenter {
    func showAlert()
    func itemSelected(at index: IndexPath)
}
