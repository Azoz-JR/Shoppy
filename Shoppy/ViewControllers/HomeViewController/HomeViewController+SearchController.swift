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
        searchVC.productsViewModel = productsViewModel
        searchVC.listsViewModel = listsViewModel
        searchVC.service = service
        searchVC.result = products
        searchVC.searchBar.becomeFirstResponder()
        
        show(searchVC, sender: self)
    }
    
//    func updateSearchResults(for searchController: UISearchController) {
        //        guard let text = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), text != "" else {
        //            productsCollectionDataSourceAndDelegate.data = products
//            reloadCollectionView()
//            return
//        }
//        
//        productsCollectionDataSourceAndDelegate.data = products.filter { product in
//            product.title.uppercased().contains(text.uppercased())
//        }
//        reloadCollectionView()
//    }
    
}
