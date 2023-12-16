//
//  CategoryViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import UIKit

class CategoryViewController: UIViewController {
    let searchController = UISearchController()
    var collectionView: UICollectionView!
    var myCollectionView: MyCollectionView!
    var cartViewModel: CartViewModel!
    
    var service: ProductsService?
    var category: Category? = nil
    var products: [Product] = []
    
    override func loadView() {
        super.loadView()
        
        configureCollectionView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let category = category else {
            return
        }

        view.backgroundColor = .systemBackground
        title = category.rawValue
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        
        configureSearchBar()
            
        refresh()
    }
    
    @objc func refresh() {
        service?.loadProducts(completion: handleAPIResults)
    }
    
    func handleAPIResults(_ result: Result<[Product], Error>) {
        switch result {
        case .success(let products):
            self.products = products
            myCollectionView.data = products
            collectionView.reloadData()
        case .failure(let error):
            self.show(error: error)
            print(error.localizedDescription)
        }
    }
    
    func configureCollectionView() {
        myCollectionView = MyCollectionView()
        myCollectionView.cartViewModel = cartViewModel
        myCollectionView.select = { [weak self] product in
            guard let self = self else {
                return
            }
            self.select(product: product, cartViewModel: self.cartViewModel)
        }
        myCollectionView.showSuccessAlert = { [weak self] in
            self?.showAddedSuccessfulyAlert()
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 180, height: 240)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(ProductCell.register(), forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.delegate = myCollectionView
        collectionView.dataSource = myCollectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

}

extension CategoryViewController: UISearchResultsUpdating {
    
    func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), text != "" else {
            myCollectionView.data = products
            reloadCollectionView()
            return
        }
        
        myCollectionView.data = products.filter { product in
            product.title.uppercased().contains(text.uppercased())
        }
        reloadCollectionView()
    }
    
}
