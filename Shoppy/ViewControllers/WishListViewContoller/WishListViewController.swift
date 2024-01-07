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
    var productsViewModel: ProductsViewModel?
    var listsViewModel: ListsViewModel?
    var wishList: [ItemViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToViewModel()
        
        configureCollectionView()
        configureSearchBar()
        
        contentView.backgroundColor = .systemBackground
        title = "Wish list"
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .navBarTint
    }
    
    func bindToViewModel() {
        listsViewModel?.wishList.addObserver { [weak self] wishList in
            guard let self, let products = wishList?.items else {
                return
            }
            
            self.wishList = products
            self.productsDataSourceAndDelegate.data = products
            reloadCollection()
            
            products.count < 5
            ? isHidingSearchBarOnScrolling(false)
            : isHidingSearchBarOnScrolling(true)
        }
    }
    
    func reloadCollection() {
        DispatchQueue.mainAsyncIfNeeded {
            UIView.transition(with: self.collectionView, duration: 0.3, options: .transitionCrossDissolve) {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadCollectionView()
    }
    
}
