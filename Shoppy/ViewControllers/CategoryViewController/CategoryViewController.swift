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
    var productsViewModel: ProductsViewModel?
    var listsViewModel: ListsViewModel?
    var service: Service?
    var collection: ItemViewModel?
    var section: Section?
    var products: [ItemViewModel] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackground()
        
        configureCollectionView()
        
        contentView.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .navBarTint
        navigationItem.backButtonDisplayMode = .minimal
        
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
            reloadCollectionView()
            
        case .failure(let error):
            self.show(error: error)
            print(error.localizedDescription)
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
    
}
