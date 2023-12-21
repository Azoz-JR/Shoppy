//
//  HomeViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var homeView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    let productsCollectionDataSourceAndDelegate = ProductsCollectionDataSourceAndDelegate()
    let categoriesCollectionDataSourceAndDelegate = CategoriesCollectionDelegate()
    let searchController = UISearchController()
    var categoriesCollectionView: UICollectionView!
    
    var cartViewModel: CartViewModel!
    let categories = Category.allCases
    var service: Service?
    var products: [ItemViewModel] = []
    var selectedIndex: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCategoriesCollection()
        configureCollectionView()
        configureCollectionDelegateAndDataSource()
        configureSearchBar()
        refresh()
    }
    
    @objc func refresh() {
        service?.loadProducts(completion: handleAPIResults)
    }
    
    func handleAPIResults(_ result: Result<[ItemViewModel], Error>) {
        switch result {
        case .success(let products):
            self.products = products
            productsCollectionDataSourceAndDelegate.data = products
            collectionView.reloadData()
        case .failure(let error):
            self.show(error: error)
            print(error.localizedDescription)
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            UIView.transition(with: self.collectionView, duration: 0.3, options: .transitionCrossDissolve) {
                self.collectionView.reloadData()
            }
        }
    }
    
}




