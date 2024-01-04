//
//  ListsControllerPresenter.swift
//  Shoppy
//
//  Created by Azoz Salah on 29/12/2023.
//

import UIKit

protocol ListsControllerPresenter {
    func listSelected(at index: Int)
    func listDeleted(at index: IndexPath)
}

// Using protocol extension to provide a default implementation of this method for the selection only scenario
extension ListsControllerPresenter {
    func listDeleted(at index: IndexPath) {
        
    }
}
