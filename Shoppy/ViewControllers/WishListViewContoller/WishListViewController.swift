//
//  WishListViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 23/12/2023.
//

import UIKit
import RxSwift

class WishListViewController: UIViewController {
    @IBOutlet var contentView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    let productsDataSourceAndDelegate = ProductsCollectionDataSourceAndDelegate()
    let searchController = UISearchController()
    var cartViewModel: CartViewModel?
    var viewModel: WishListViewModel!
    var listsViewModel: ListsViewModel?
    var wishListProducts: [ItemModel] = []
    let disposeBag = DisposeBag()
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configRefreshView()
        bindToViewModel()
        configureCollectionView()
        configureSearchBar()
        
        contentView.backgroundColor = .systemBackground
        title = "Wish list"
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .navBarTint
        
        refresh()
    }
    
    func bindToViewModel() {
        viewModel.wishList.subscribe { [weak self] wishList in
            guard let self else {
                return
            }
            
            self.wishListProducts = wishList.items
            self.productsDataSourceAndDelegate.data = wishList.items
            reloadCollection()
            
            wishList.items.count < 5
            ? isHidingSearchBarOnScrolling(false)
            : isHidingSearchBarOnScrolling(true)
        }
        .disposed(by: disposeBag)
        
    }
    
    @objc func refresh() {
        viewModel.getWishList() { [weak self] in
            self?.refreshControl.endRefreshing()
        }
        
    }
    
    func reloadCollection() {
        DispatchQueue.mainAsyncIfNeeded {
            UIView.transition(with: self.collectionView, duration: 0.3, options: .transitionCrossDissolve) {
                self.collectionView.reloadData()
            }
        }
    }
    
    func configRefreshView() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .myGreen
        collectionView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadCollectionView()
    }
    
}
