//
//  CollectionViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import UIKit

final class CollectionViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var contentView: UIView!
    
    
    
    let productsDataSourceAndDelegate = ProductsCollectionDataSourceAndDelegate()
    let searchController = UISearchController()
    var cartViewModel: CartViewModel?
    var listsViewModel: ListsViewModel?
    var wishListViewModel: WishListViewModel?
    var service: Service?
    var collection: ItemViewModel?
    var section: Section?
    var products: [ItemViewModel] = []
    var viewModel = CollectionViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .navBarTint
        navigationItem.backButtonDisplayMode = .minimal
        
        viewModel.service = service
        bindToViewModel()
        
        configureBackground()
        configureCollectionView()
        configureSearchBar()
        
        refresh()
        
        if let section {
            products = section.items
            productsDataSourceAndDelegate.data = products
            reloadCollectionView()
            
            products.count < 5
            ? isHidingSearchBarOnScrolling(false)
            : isHidingSearchBarOnScrolling(true)
        }
        
    }
    
    func bindToViewModel() {
        viewModel.products.addObserver { [weak self] products in
            guard let self, let products else {
                return
            }
            
            self.products = products
            productsDataSourceAndDelegate.data = products
            reloadCollectionView()
            
            products.count < 5
            ? isHidingSearchBarOnScrolling(false)
            : isHidingSearchBarOnScrolling(true)
        }
        
        viewModel.error.addObserver { [weak self] error in
            guard let self, let error else {
                return
            }
            
            self.show(error: error)
        }
    }
    
    @objc func refresh() {
        Task {
            await viewModel.load()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        reloadCollectionView()
    }
    
    func configureBackground() {
        guard let collection else {
            return
        }
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.sd_setImage(with: collection.image)
        collectionView.backgroundView = imageView
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.5
        blurEffectView.frame = collectionView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(blurEffectView)
    }
    
    /*
//    @objc func refresh() {
//        service?.loadProducts(completion: handleAPIResults)
//    }
//    
//    func handleAPIResults(_ result: Result<[ItemViewModel], Error>) {
//        switch result {
//        case .success(let products):
//            products.count < 5
//            ? isHidingSearchBarOnScrolling(false)
//            : isHidingSearchBarOnScrolling(true)
//            self.products = products
//            productsDataSourceAndDelegate.data = products
//            reloadCollectionView()
//            
//        case .failure(let error):
//            self.show(error: error)
//            print(error.localizedDescription)
//        }
//    }
     */
    
}
