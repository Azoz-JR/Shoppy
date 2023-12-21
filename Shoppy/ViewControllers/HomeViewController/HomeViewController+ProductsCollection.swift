//
//  HomeViewController+ProductsCollection.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import UIKit

extension HomeViewController: HomeProductsPresenter {
    
    func configureCollectionDelegateAndDataSource() {
        collectionView.delegate = productsCollectionDataSourceAndDelegate
        collectionView.dataSource = productsCollectionDataSourceAndDelegate
        
        productsCollectionDataSourceAndDelegate.cartViewModel = cartViewModel
        productsCollectionDataSourceAndDelegate.parentController = self
    }
    
    func configureCollectionView() {
        collectionView.register(ProductCell.register(), forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 70, left: .zero, bottom: .zero, right: .zero)
    }
    
    func showAlert() {
        showAddedSuccessfulyAlert()
    }
    
    func itemSelected(at index: IndexPath) {
        let product = products[index.row]
        select(product: product, cartViewModel: cartViewModel)
    }
    
}
