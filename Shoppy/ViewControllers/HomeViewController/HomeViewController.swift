//
//  HomeViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet var homeView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    let collectionDataSourceAndDelegate = HomeCollectionDataSourceAndDelegate()
    let categoriesCollectionDataSourceAndDelegate = CategoriesCollectionDelegate()
    let searchController = UISearchController()
    var categoriesCollectionView: UICollectionView!
    private var refreshControl = UIRefreshControl()
    let searchBar = UISearchBar()
    
    var productsViewModel: ProductsViewModel?
    var listsViewModel: ListsViewModel?
    let categories = Category.allCases
    var service: Service?
    var sections: [Section] = []
    var products: [ItemViewModel] = []
    //var selectedIndex: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .navBarTint
        navigationItem.backButtonDisplayMode = .minimal
        
        configureCategoriesCollection()
        configureCollectionView()
        configureCollectionDelegateAndDataSource()
        configureSearchBar()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .myGreen
        collectionView.refreshControl = refreshControl
        
        refresh()
    }
    
    @objc func refresh() {
        service?.loadProducts(completion: handleAPIResults)
    }
    
    func handleAPIResults(_ result: Result<[ItemViewModel], Error>) {
        switch result {
        case .success(let products):
            self.products = products
            
            self.sections = [Section(title: "Recomended for you", items: products.filter({$0.vendor == "ADIDAS"})), Section(title: "Most popular", items: products.filter({$0.vendor == "NIKE"})), Section(title: "Shoes", items: products.filter({$0.category == .shoes})), Section(title: "Accessories", items: products.filter({$0.category == .accessories})), Section(title: "T-Shirts", items: products.filter({$0.category == .tShirts}))]
            
            collectionDataSourceAndDelegate.data = sections
            reloadCollectionView()
        case .failure(let error):
            self.show(error: error)
            print(error.localizedDescription)
        }
        
        refreshControl.endRefreshing()
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            UIView.transition(with: self.collectionView, duration: 0.3, options: .transitionCrossDissolve) {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.resignFirstResponder()
        reloadCollectionView()
    }
    
}
