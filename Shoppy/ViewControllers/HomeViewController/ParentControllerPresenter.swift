//
//  ParentControllerPresenter.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import Foundation

protocol ParentControllerPresenter {
    func showAlert()
    func itemSelected(at index: IndexPath)
}

protocol HomeCategoriesPresenter {
    func categorySelected(at index: IndexPath)
}
