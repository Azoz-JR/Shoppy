//
//  CategoryViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import UIKit

final class CategoriesViewController: UIViewController, CategoriesPresenter {
    @IBOutlet var collectionView: UICollectionView!
    
    let collectionDataSourceAndDelegate = CategoriesCollectionDataSourceAndDelegate()
    var productsViewModel: ProductsViewModel?
    var listsViewModel: ListsViewModel?
    private var collections: [ItemViewModel] = []
    var service: Service? = CollectionsAPIServiceAdapter(api: CollectionsAPI.shared)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .navBarTint
        configureCollection()
        
        refresh()
    }
    
    func configureCollection() {
        collectionView.register(CollectionCell.register(), forCellWithReuseIdentifier: CollectionCell.identifier)
        
        collectionView.delegate = collectionDataSourceAndDelegate
        collectionView.dataSource = collectionDataSourceAndDelegate
        
        collectionDataSourceAndDelegate.parentController = self
    }
    
    func refresh() {
        service?.loadProducts(completion: handleAPIResults)
    }
    
    func handleAPIResults(_ result: Result<[ItemViewModel], Error>) {
        switch result {
        case .success(let collections):
            self.collections = collections
            collectionDataSourceAndDelegate.data = collections
            reloadCollection()
        case .failure(let error):
            self.show(error: error)
            print(error.localizedDescription)
        }
    }

    func categorySelected(at index: IndexPath) {
        let vc = CategoryViewController()
        vc.productsViewModel = productsViewModel
        vc.listsViewModel = listsViewModel
        let collection = collections[index.row]
        vc.collection = collection
        
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
    
}
