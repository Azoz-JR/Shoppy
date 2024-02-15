//
//  ListDetailViewPresenter.swift
//  Shoppy
//
//  Created by Azoz Salah on 05/01/2024.
//

import Foundation

protocol ListDetailViewPresenter {
    func showAlert(error: Error?)
    func itemSelected(at index: IndexPath)
    func itemDeleted(at index: IndexPath)
}
