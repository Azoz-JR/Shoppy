//
//  WishListViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 23/12/2023.
//

import UIKit

class WishListViewController: UIViewController {
    @IBOutlet var contentView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    let productsDataSourceAndDelegate = ProductsCollectionDataSourceAndDelegate()
    let searchController = UISearchController()
    var productsViewModel: ProductsViewModel!
    var likedProducts: [ItemViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToViewModel()
        
        configureCollectionView()
        configureSearchBar()
        
        contentView.backgroundColor = .systemBackground
        title = "Wish list"
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func bindToViewModel() {
        productsViewModel.likedProducts.bind { [weak self] products in
            guard let self, let products else {
                return
            }
            
            self.likedProducts = products
            self.productsDataSourceAndDelegate.data = products
            reloadCollection()
        }
    }
    
    func reloadCollection() {
        DispatchQueue.mainAsyncIfNeeded {
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadCollectionView()
    }
    
}
