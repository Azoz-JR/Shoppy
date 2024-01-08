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
        
        collectionDataSourceAndDelegate.listsViewModel = listsViewModel
        collectionDataSourceAndDelegate.parentController = self
    }
    
    func configureCollectionView() {
        collectionView.register(ProductCell.register(), forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.register(ProductsCollectionReusableView.register(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProductsCollectionReusableView.identifier)
        
        collectionView.contentInset = UIEdgeInsets(top: 70, left: .zero, bottom: .zero, right: .zero)
    }
    
    func itemSelected(at index: IndexPath) {
        let product = sections[index.section].items[index.row]
        guard let productsViewModel, let listsViewModel else {
            return
        }
        
        select(product: product, productsViewModel: productsViewModel, listsViewModel: listsViewModel)
    }
    
    func setionSelected(at index: IndexPath) {
        let vc = CategoryViewController()
        vc.productsViewModel = productsViewModel
        vc.listsViewModel = listsViewModel
        let section = sections[index.section]
        vc.section = section
        vc.title = section.title
        
//        let api = ProductsAPIServiceAdapter(api: ProductsAPI.shared, category: collection.title)
//        vc.service = api
        
        show(vc, sender: self)
    }
    
}
