//
//  CategoryViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import UIKit

final class CategoryViewController: UIViewController {
    @IBOutlet var contentView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    let productsDataSourceAndDelegate = ProductsCollectionDataSourceAndDelegate()
    let searchController = UISearchController()
    var productsViewModel: ProductsViewModel!
    var service: Service?
    var category: String? = nil
    var products: [ItemViewModel] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let category = category else {
            return
        }
        
        configureCollectionView()
        
        contentView.backgroundColor = .systemBackground
        title = category
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        
        configureSearchBar()
            
        refresh()
    }
    
    @objc func refresh() {
        service?.loadProducts(completion: handleAPIResults)
    }
    
    func handleAPIResults(_ result: Result<[ItemViewModel], Error>) {
        switch result {
        case .success(let products):
            products.count < 5
            ? isHidingSearchBarOnScrolling(false)
            : isHidingSearchBarOnScrolling(true)
            self.products = products
            productsDataSourceAndDelegate.data = products
            collectionView.reloadData()
        case .failure(let error):
            self.show(error: error)
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadCollectionView()
    }
    
}
