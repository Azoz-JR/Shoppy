//
//  HomeViewController+ProductsCollection.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import UIKit

extension HomeViewController: HomeControllerPresenter {
    
    func configureCollectionDelegateAndDataSource() {
        collectionView.delegate = collectionDataSourceAndDelegate
        collectionView.dataSource = collectionDataSourceAndDelegate
        collectionView.keyboardDismissMode = .onDrag
        
        collectionDataSourceAndDelegate.wishListViewModel = wishListViewModel
        collectionDataSourceAndDelegate.parentController = self
    }
    
    func configureCollectionView() {
        collectionView.register(ProductCell.register(), forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.register(ProductsCollectionReusableView.register(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProductsCollectionReusableView.identifier)
        
        collectionView.contentInset = UIEdgeInsets(top: 70, left: .zero, bottom: .zero, right: .zero)
    }
    
    func itemSelected(at index: IndexPath) {
        let product = homeViewModel.sections[index.section].items[index.row]
        guard let cartViewModel, let listsViewModel, let wishListViewModel else {
            return
        }
        
        select(product: product, cartViewModel: cartViewModel, listsViewModel: listsViewModel, wishListViewModel: wishListViewModel)
    }
    
    func setionSelected(at index: IndexPath) {
        let vc = CollectionViewController()
        vc.cartViewModel = cartViewModel
        vc.listsViewModel = listsViewModel
        vc.wishListViewModel = wishListViewModel
        let section = homeViewModel.sections[index.section]
        vc.section = section
        vc.title = section.title
        
//        let api = ProductsAPIServiceAdapter(api: ProductsAPI.shared, category: collection.title)
//        vc.service = api
        
        show(vc, sender: self)
    }
    
}
