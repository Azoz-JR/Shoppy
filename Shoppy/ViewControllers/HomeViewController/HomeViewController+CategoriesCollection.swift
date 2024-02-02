//
//  HomeViewController+CategoriesCollection.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import UIKit

extension HomeViewController {
    
    var categories: [Category] {
        return Category.allCases
    }
    
    func categorySelected(at index: IndexPath) {
        let category = categories[index.row]
        let section = Section(title: category.rawValue, items: products.filter({ $0.category == category}))
        
        let vc = CollectionViewController()
        vc.cartViewModel = cartViewModel
        vc.listsViewModel = listsViewModel
        vc.wishListViewModel = wishListViewModel
        vc.section = section
        vc.title = section.title
        
        show(vc, sender: self)
    }
    
}
