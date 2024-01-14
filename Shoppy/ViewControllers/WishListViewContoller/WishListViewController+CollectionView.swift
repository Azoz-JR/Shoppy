//
//  WishListViewController+CollectionView.swift
//  Shoppy
//
//  Created by Azoz Salah on 23/12/2023.
//

import UIKit

extension WishListViewController: ParentControllerPresenter {
    func configureCollectionView() {
        productsDataSourceAndDelegate.parentController = self
        productsDataSourceAndDelegate.wishListViewModel = viewModel
        
        collectionView.register(ProductCell.register(), forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.delegate = productsDataSourceAndDelegate
        collectionView.dataSource = productsDataSourceAndDelegate
        collectionView.keyboardDismissMode = .onDrag
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
        let product = productsDataSourceAndDelegate.data[index.row]
        guard let listsViewModel, let cartViewModel else {
            return
        }
        
        select(product: product, cartViewModel: cartViewModel, listsViewModel: listsViewModel, wishListViewModel: viewModel)
    }
}
