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
    var categoriesCollectionView: UICollectionView!
    private var refreshControl = UIRefreshControl()
    let searchBar = UISearchBar()
    
    var cartViewModel: CartViewModel?
    var listsViewModel: ListsViewModel?
    var wishListViewModel: WishListViewModel?
    var homeViewModel = HomeViewModel()
    
    var tabBarVisible = true
    var lastContentOffset: CGFloat = 0
    
    let collectionDataSourceAndDelegate = HomeCollectionDataSourceAndDelegate()
    let categoriesCollectionDataSourceAndDelegate = CategoriesCollectionDelegate()
    
    var service: Service?
    var sections: [Section] = []
    var products: [ItemViewModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .navBarTint
        navigationItem.backButtonDisplayMode = .minimal
                
        bindToViewModel()
        
        configureSearchBar()
        configureCollectionView()
        configureCollectionDelegateAndDataSource()
        configureCategoriesCollection()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .myGreen
        collectionView.refreshControl = refreshControl
        
        refresh()
    }
    
    func bindToViewModel() {
        homeViewModel.sections.addObserver { [weak self] sections in
            guard let sections, let self else {
                return
            }
            
            self.sections = sections
            collectionDataSourceAndDelegate.data = sections
            reloadCollectionView()
        }
        
        homeViewModel.products.addObserver { [weak self] products in
            guard let self, let products else {
                return
            }
            
            self.products = products
        }
        
        homeViewModel.error.addObserver { [weak self] error in
            guard let self, let error else {
                return
            }
            
            self.show(error: error)
        }
    }
    
    @objc func refresh() {
        Task(priority: .background) {
            await homeViewModel.load()
            
            refreshControl.endRefreshing()
        }
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
    
    /*
//    @objc func refresh() {
//        service?.loadProducts(completion: handleAPIResults)
//    }
    
//    func handleAPIResults(_ result: Result<[ItemViewModel], Error>) {
//        switch result {
//        case .success(let products):
//            self.products = products
//            
//            self.sections = [Section(title: "Recomended for you", items: products.filter({$0.vendor == "ADIDAS"})), Section(title: "Most popular", items: products.filter({$0.vendor == "NIKE"})), Section(title: "Shoes", items: products.filter({$0.category == .shoes})), Section(title: "Accessories", items: products.filter({$0.category == .accessories})), Section(title: "T-Shirts", items: products.filter({$0.category == .tShirts}))]
//            
//            collectionDataSourceAndDelegate.data = sections
//            reloadCollectionView()
//        case .failure(let error):
//            self.show(error: error)
//            print(error.localizedDescription)
//        }
//        
//        refreshControl.endRefreshing()
//    }
     */
    
}
