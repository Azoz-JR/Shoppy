//
//  CategoryViewController+Collection.swift
//  Shoppy
//
//  Created by Azoz Salah on 22/12/2023.
//

import UIKit

extension CategoryViewController: ParentControllerPresenter {
    
    func configureCollectionView() {
        productsDataSourceAndDelegate.productsViewModel = productsViewModel
        productsDataSourceAndDelegate.listsViewModel = listsViewModel
        productsDataSourceAndDelegate.parentController = self
        
        collectionView.register(ProductCell.register(), forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.delegate = productsDataSourceAndDelegate
        collectionView.dataSource = productsDataSourceAndDelegate
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            UIView.transition(with: self.collectionView, duration: 0.3, options: .transitionCrossDissolve) {
                self.collectionView.reloadData()
            }
        }
    }
    
    func showAlert() {
        showAddedSuccessfulyAlert()
    }
    
    func itemSelected(at index: IndexPath) {
        let product = products[index.row]
        guard let productsViewModel, let listsViewModel else {
            return
        }
        
        select(product: product, productsViewModel: productsViewModel, listsViewModel: listsViewModel)
    }
}
