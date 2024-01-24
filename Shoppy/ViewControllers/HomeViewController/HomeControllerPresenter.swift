//
//  HomeControllerPresenter.swift
//  Shoppy
//
//  Created by Azoz Salah on 08/01/2024.
//

import UIKit

protocol HomeControllerPresenter: ScrollViewDelegate {
    func itemSelected(at index: IndexPath)
    func setionSelected(at index: IndexPath)
}

protocol HomeCategoriesPresenter: AnyObject {
    func categorySelected(at index: IndexPath)
}

protocol ScrollViewDelegate: AnyObject {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}
