//
//  CategoryViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import UIKit

class CategoriesViewController: UIViewController, CategoriesPresenter {
    @IBOutlet var collectionView: UICollectionView!
    
    let collectionDataSourceAndDelegate = CategoriesCollectionDataSourceAndDelegate()
    var cartViewModel: CartViewModel!
    private var collections: [ItemViewModel] = []
    var service: Service? = CollectionsAPIServiceAdapter(api: CollectionsAPI.shared)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            collectionView.reloadData()
        case .failure(let error):
            self.show(error: error)
            print(error.localizedDescription)
        }
    }

    func categorySelected(at index: IndexPath) {
        let vc = CategoryViewController()
        vc.cartViewModel = cartViewModel
        let collection = collections[index.row]
        vc.category = collection.title
        
        let api = ProductsAPIServiceAdapter(api: ProductsAPI.shared, category: collection.title)
        vc.service = api
        
        show(vc, sender: self)
    }
    
}
