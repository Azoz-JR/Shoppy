//
//  CollectionsViewController+CollectionView.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/03/2024.
//

import UIKit

extension CollectionsViewController {
    func configureCollection() {
        collectionView.register(CollectionCell.register(), forCellWithReuseIdentifier: CollectionCell.identifier)
        
        collectionView.delegate = collectionDataSourceAndDelegate
        collectionView.dataSource = collectionDataSourceAndDelegate
        
        collectionDataSourceAndDelegate.parentController = self
    }
    
    func collectionSelected(at index: IndexPath) {
        let vc = CollectionViewController()
        vc.cartViewModel = cartViewModel
        vc.listsViewModel = listsViewModel
        vc.wishListViewModel = wishListViewModel
        let collection = collections[index.row]
        vc.collection = collection
        vc.title = collection.title
        
        let api = ProductsAPIServiceAdapter(api: ProductsAPI.shared, category: collection.title)
        vc.service = api
        
        show(vc, sender: self)
    }
}
