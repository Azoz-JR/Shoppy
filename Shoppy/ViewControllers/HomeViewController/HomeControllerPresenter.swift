//
//  HomeControllerPresenter.swift
//  Shoppy
//
//  Created by Azoz Salah on 08/01/2024.
//

import Foundation

protocol HomeControllerPresenter {
    func itemSelected(at index: IndexPath)
    func setionSelected(at index: IndexPath)
}

protocol HomeCategoriesPresenter {
    func categorySelected(at index: IndexPath)
}
