//
//  HomeViewController+SearchController.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import UIKit

extension HomeViewController: UISearchResultsUpdating {
    
    func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
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
    }
    
}
