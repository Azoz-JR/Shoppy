//
//  WishListViewController+Search.swift
//  Shoppy
//
//  Created by Azoz Salah on 23/12/2023.
//

import UIKit

extension WishListViewController: UISearchResultsUpdating {
    func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), text != "" else {
            productsDataSourceAndDelegate.data = products
            reloadCollectionView()
            return
        }
        
        productsDataSourceAndDelegate.data = products.filter { product in
            product.title.localizedStandardContains(text)
        }
        reloadCollectionView()
    }
}
