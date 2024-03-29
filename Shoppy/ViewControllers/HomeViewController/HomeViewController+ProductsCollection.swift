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
        collectionView.register(SmallCategoryCollectionCell.register(), forCellWithReuseIdentifier: SmallCategoryCollectionCell.identifier)
        collectionView.register(SalesCellView.register(), forCellWithReuseIdentifier: SalesCellView.identifier)
        collectionView.register(ProductCell.register(), forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.register(ProductsCollectionReusableView.register(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProductsCollectionReusableView.identifier)
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
        
        show(vc, sender: self)
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            UIView.transition(with: self.collectionView, duration: 0.3, options: .transitionCrossDissolve) {
                self.collectionView.reloadData()
            }
        }
    }
    
}
