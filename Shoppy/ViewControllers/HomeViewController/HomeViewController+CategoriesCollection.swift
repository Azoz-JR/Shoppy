//
//  HomeViewController+CategoriesCollection.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import UIKit

extension HomeViewController: HomeCategoriesPresenter {
    
    func configureCategoriesCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 125, height: 30)
        layout.scrollDirection = .horizontal
        
        categoriesCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30), collectionViewLayout: layout)
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.register(SmallCategoryCell.register(), forCellWithReuseIdentifier: SmallCategoryCell.identifier)
        collectionView.addSubview(categoriesCollectionView)
                        
        
        NSLayoutConstraint.activate([
            categoriesCollectionView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -30),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        configureCategoriesDelegateAndDataSource()
    }
    
    func configureCategoriesDelegateAndDataSource() {
        categoriesCollectionDataSourceAndDelegate.parentController = self
        
        categoriesCollectionView.delegate = categoriesCollectionDataSourceAndDelegate
        categoriesCollectionView.dataSource = categoriesCollectionDataSourceAndDelegate
    }
    
    func filterProducts(category: Category?) {
//        guard let category = category else {
//            productsCollectionDataSourceAndDelegate.data = products
//            reloadCollectionView()
//            return
//        }
//        
//        productsCollectionDataSourceAndDelegate.data = products.filter { product in
//            product.category == category
//        }
//        reloadCollectionView()
    }
    
    func categorySelected(at index: IndexPath) {
        guard let selectedIndex = selectedIndex else {
            selectedIndex = index
            filterProducts(category: categories[index.row])
            return
        }
        
        if selectedIndex != index {
            categoriesCollectionView.deselectItem(at: selectedIndex, animated: true)
            self.selectedIndex = index
            filterProducts(category: categories[index.row])
            return
        }
        
        // Selecting the currently selectedIndex condition
        categoriesCollectionView.deselectItem(at: selectedIndex, animated: true)
        self.selectedIndex = nil
        filterProducts(category: nil)
    }
    
}
