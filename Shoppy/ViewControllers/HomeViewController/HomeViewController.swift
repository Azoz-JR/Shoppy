//
//  HomeViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    @IBOutlet var homeView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    var categoriesCollectionView: UICollectionView!
    private var refreshControl = UIRefreshControl()
    let searchBar = UISearchBar()
    private let disposeBag = DisposeBag()
    
    var cartViewModel: CartViewModel?
    var listsViewModel: ListsViewModel?
    var wishListViewModel: WishListViewModel?
    var homeViewModel = HomeViewModel()
    
    var tabBarVisible = true
    var lastContentOffset: CGFloat = 0
    
    let collectionDataSourceAndDelegate = HomeCollectionDataSourceAndDelegate()
    let categoriesCollectionDataSourceAndDelegate = CategoriesCollectionDelegate()
    
    var service: Service?
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
        homeViewModel.productsObservable
            .subscribe { [weak self] products in
                guard let self else {
                    return
                }
                
                self.products = products
                self.collectionDataSourceAndDelegate.data = self.homeViewModel.sections
                self.reloadCollectionView()
                self.refreshControl.endRefreshing()
                
            } onError: { [weak self] error in
                self?.show(error: error)
                self?.refreshControl.endRefreshing()
            }
            .disposed(by: disposeBag)
    }
    
    @objc func refresh() {
        Task(priority: .background) {
            await homeViewModel.load()
            
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        showTabBar()
    }
    
}
