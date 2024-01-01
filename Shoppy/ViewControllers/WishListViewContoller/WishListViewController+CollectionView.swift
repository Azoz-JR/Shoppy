//
//  WishListViewController+CollectionView.swift
//  Shoppy
//
//  Created by Azoz Salah on 23/12/2023.
//

import UIKit

extension WishListViewController: ParentControllerPresenter {
    func configureCollectionView() {
        productsDataSourceAndDelegate.productsViewModel = productsViewModel
        productsDataSourceAndDelegate.parentController = self
        productsDataSourceAndDelegate.listsViewModel = listsViewModel
        
        collectionView.register(ProductCell.register(), forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.delegate = productsDataSourceAndDelegate
        collectionView.dataSource = productsDataSourceAndDelegate
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showAlert() {
        showAddedSuccessfulyAlert()
    }
    
    func itemSelected(at index: IndexPath) {
        let product = wishList[index.row]
        select(product: product, productsViewModel: productsViewModel, listsViewModel: listsViewModel)
    }
}
