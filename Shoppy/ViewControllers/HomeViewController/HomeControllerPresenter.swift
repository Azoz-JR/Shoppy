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

protocol HomeCategoriesPresenter {
    func categorySelected(at index: IndexPath)
}

protocol ScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    func scrollViewDidScroll(_ scrollView: UIScrollView)
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
}
