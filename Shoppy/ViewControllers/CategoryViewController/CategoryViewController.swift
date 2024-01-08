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
    var collection: ItemViewModel? = nil
    var products: [ItemViewModel] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let collection else {
            return
        }
        
        configureCollectionView()
        configureBackground()
        
        contentView.backgroundColor = .systemBackground
        title = collection.title
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .navBarTint
        
        configureSearchBar()
            
        refresh()
    }
    
    func configureBackground() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.sd_setImage(with: collection?.image)
        collectionView.backgroundView = imageView
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.5
        blurEffectView.frame = collectionView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(blurEffectView)
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
        
        reloadCollectionView()
    }
    
}
