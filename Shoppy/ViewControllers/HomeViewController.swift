//
//  HomeViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import UIKit

class HomeViewController: UIViewController {
    let searchController = UISearchController()
    var collectionView: UICollectionView!
    var categoriesCollectionView: UICollectionView!
    
    var myCollectionView: MyCollectionView!
    var cartViewModel: CartViewModel!
    
    let categories = Category.allCases
    var service: Service?
    var products: [ItemViewModel] = []
    var selectedIndex: IndexPath?
    
    override func loadView() {
        super.loadView()

        configureCollectionView()
        configureCategoriesCollection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        refresh()
    }
    
    @objc func refresh() {
        service?.loadProducts(completion: handleAPIResults)
    }
    
    func handleAPIResults(_ result: Result<[ItemViewModel], Error>) {
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
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.itemSize = CGSize(width: (view.bounds.width / 2) - 20, height: 250)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(ProductCell.register(), forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.delegate = myCollectionView
        collectionView.dataSource = myCollectionView
        collectionView.contentInset = UIEdgeInsets(top: 70, left: .zero, bottom: .zero, right: .zero)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        //Set CollectionView Constraints
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            UIView.transition(with: self.collectionView, duration: 0.3, options: .transitionCrossDissolve) {
                self.collectionView.reloadData()
            }
        }
    }
    
    func filterProducts(category: Category?) {
        guard let category = category else {
            myCollectionView.data = products
            reloadCollectionView()
            return
        }
        
        myCollectionView.data = products.filter { product in
            product.category == category
        }
        reloadCollectionView()
        
    }
    
}


extension HomeViewController: UISearchResultsUpdating {
    
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

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func configureCategoriesCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 125, height: 40)
        layout.scrollDirection = .horizontal
        
        categoriesCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100), collectionViewLayout: layout)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.register(SmallCategoryCell.register(), forCellWithReuseIdentifier: SmallCategoryCell.identifier)
        
        collectionView.addSubview(categoriesCollectionView)
        
        categoriesCollectionView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        categoriesCollectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: SmallCategoryCell.identifier, for: indexPath) as? SmallCategoryCell {
            cell.configure(with: categories[indexPath.row])
            
            return cell
        }
        fatalError("Unable to dequeue CategoryCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let selectedIndex = selectedIndex else {
            selectedIndex = indexPath
            filterProducts(category: categories[indexPath.row])
            return
        }
        
        if selectedIndex != indexPath {
            collectionView.deselectItem(at: selectedIndex, animated: true)
            self.selectedIndex = indexPath
            filterProducts(category: categories[indexPath.row])
            return
        }
        
        // Selecting the currently selectedIndex condition
        collectionView.deselectItem(at: selectedIndex, animated: true)
        self.selectedIndex = nil
        filterProducts(category: nil)
        
        
    }
    
}
