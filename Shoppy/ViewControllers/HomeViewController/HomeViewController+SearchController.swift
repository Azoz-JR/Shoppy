//
//  HomeViewController+SearchController.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import UIKit

extension HomeViewController: UISearchBarDelegate {
    
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search Shoppy"
        searchBar.tintColor = UIColor.lightGray
        searchBar.barTintColor = UIColor.lightGray
        navigationItem.titleView = searchBar
        searchBar.isTranslucent = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let searchVC = SearchViewController()
        searchVC.cartViewModel = cartViewModel
        searchVC.listsViewModel = listsViewModel
        searchVC.service = service
        searchVC.result = products
        searchVC.wishListViewModel = wishListViewModel
        searchVC.searchBar.becomeFirstResponder()
        
        show(searchVC, sender: self)
    }
    
}
