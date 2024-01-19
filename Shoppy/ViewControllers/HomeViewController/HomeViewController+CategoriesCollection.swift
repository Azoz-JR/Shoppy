//
//  HomeViewController+CategoriesCollection.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import UIKit

extension HomeViewController: HomeCategoriesPresenter {
    
    var categories: [Category] {
        return Category.allCases
    }
    
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
            categoriesCollectionView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10),
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
    
    func categorySelected(at index: IndexPath) {
        let category = categories[index.row]
        let section = Section(title: category.rawValue, items: products.filter({ $0.category == category}))
        
        let vc = CollectionViewController()
        vc.cartViewModel = cartViewModel
        vc.listsViewModel = listsViewModel
        vc.wishListViewModel = wishListViewModel
        vc.section = section
        vc.title = section.title
        
        show(vc, sender: self)
    }
    
}
