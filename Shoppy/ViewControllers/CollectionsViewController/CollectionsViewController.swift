//
//  CollectionsViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import UIKit

final class CollectionsViewController: UIViewController, CollectionsPresenter {
    @IBOutlet var collectionView: UICollectionView!
    
    var viewModel = CollectionsViewModel()
    var cartViewModel: CartViewModel?
    var listsViewModel: ListsViewModel?
    var wishListViewModel: WishListViewModel?
    var service: Service?
    
    let collectionDataSourceAndDelegate = CollectionsDataSourceAndDelegate()
    private var collections: [ItemViewModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .navBarTint
        configureCollection()
        
        bindToViewModel()
        
        refresh()
    }
    
    func bindToViewModel() {
        viewModel.collections.addObserver { [weak self] collections in
            guard let self, let collections else {
                return
            }
            
            self.collections = collections
            collectionDataSourceAndDelegate.data = collections
            reloadCollection()
        }
        
        viewModel.error.addObserver { [weak self] error in
            guard let self, let error else {
                return
            }
            
            self.show(error: error)
        }
    }
    
    func configureCollection() {
        collectionView.register(CollectionCell.register(), forCellWithReuseIdentifier: CollectionCell.identifier)
        
        collectionView.delegate = collectionDataSourceAndDelegate
        collectionView.dataSource = collectionDataSourceAndDelegate
        
        collectionDataSourceAndDelegate.parentController = self
    }
    
    func refresh() {
        Task {
            await viewModel.load()
        }
    }
    
    func categorySelected(at index: IndexPath) {
        let vc = CollectionViewController()
        vc.cartViewModel = cartViewModel
        vc.listsViewModel = listsViewModel
        let collection = collections[index.row]
        vc.collection = collection
        vc.title = collection.title
        
        let api = ProductsAPIServiceAdapter(api: ProductsAPI.shared, category: collection.title)
        vc.service = api
        
        show(vc, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func reloadCollection() {
        UIView.transition(with: self.collectionView, duration: 0.3, options: .transitionCrossDissolve) {
            self.collectionView.reloadData()
        }
    }
    
    /*
//    func refresh() {
//        service?.loadProducts(completion: handleAPIResults)
//    }
//    
//    func handleAPIResults(_ result: Result<[ItemViewModel], Error>) {
//        switch result {
//        case .success(let collections):
//            self.collections = collections
//            collectionDataSourceAndDelegate.data = collections
//            reloadCollection()
//        case .failure(let error):
//            self.show(error: error)
//            print(error.localizedDescription)
//        }
//    }
     */
    
}
