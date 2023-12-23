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
    var cartViewModel: CartViewModel!
    var products: [ItemViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        
        contentView.backgroundColor = .systemBackground
        title = "Wish list"
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        
        configureSearchBar()
    }
    
}
