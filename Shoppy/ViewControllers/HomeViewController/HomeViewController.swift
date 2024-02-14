//
//  HomeViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    var categoriesCollectionView: UICollectionView!
    
    let homeViewModel = HomeViewModel()
    private var refreshControl = UIRefreshControl()
    let searchBar = UISearchBar()
    let progressView = ProgressView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    private let disposeBag = DisposeBag()
    
    var cartViewModel: CartViewModel?
    var listsViewModel: ListsViewModel?
    var wishListViewModel: WishListViewModel?

    // Show/Hide TabBar properties
    var tabBarVisible = true
    var lastContentOffset: CGFloat = 0
    
    let collectionDataSourceAndDelegate = HomeCollectionDataSourceAndDelegate()
    var products: [ItemModel] = []
    
    var service: Service?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setUpHomeView()
        configureSearchBar()
        configureCollectionView()
        setUpProgressView()
        configureCollectionDelegateAndDataSource()
        bindToViewModel()
        
        showProgressView()
        refresh()
    }
    
    func setUpHomeView() {
        view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .navBarTint
        navigationItem.backButtonDisplayMode = .minimal
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .myGreen
        collectionView.refreshControl = refreshControl
    }
    
    func setUpProgressView() {
        view.addSubview(progressView)
        progressView.center = view.center
        progressView.isHidden = true
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
        Task {
            checkIfRetryNeeded()
            
            await homeViewModel.load()
            
            await MainActor.run {
                self.hideProgressView()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func checkIfRetryNeeded() {
        if homeViewModel.isRetryNeeded {
            homeViewModel.resetBehaviorSubject()
            
            bindToViewModel()
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
    
    func showProgressView() {
        progressView.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func hideProgressView() {
        progressView.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
}
