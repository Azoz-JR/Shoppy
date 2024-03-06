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
    
    let collectionDataSourceAndDelegate = CollectionsDataSourceAndDelegate()
    var collections: [ItemModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Collections"
        
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
    

    
    func refresh() {
        Task {
            await viewModel.load()
        }
    }
    
    func reloadCollection() {
        UIView.transition(with: self.collectionView, duration: 0.3, options: .transitionCrossDissolve) {
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
