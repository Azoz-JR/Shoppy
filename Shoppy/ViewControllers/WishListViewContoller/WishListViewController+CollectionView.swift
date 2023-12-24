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
        let product = likedProducts[index.row]
        select(product: product, productsViewModel: productsViewModel)
    }
}
