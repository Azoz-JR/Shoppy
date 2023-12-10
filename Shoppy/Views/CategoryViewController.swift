//
//  CategoryViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import UIKit

class CategoryViewController: UIViewController {
    var collectionView: UICollectionView!
    var myCollectionView: MyCollectionView!
    
    var service: ProductsService?
    var category: Category? = nil
    
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
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            // Collection View Constraints
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
            
        refresh()
    }
    
    @objc func refresh() {
        service?.loadProducts(completion: handleAPIResults)
    }
    
    func handleAPIResults(_ result: Result<[Product], Error>) {
        switch result {
        case .success(let products):
            myCollectionView.data = products
            collectionView.reloadData()
        case .failure(let error):
            self.show(error: error)
            print(error.localizedDescription)
        }
    }
    
    func configureCollectionView() {
        myCollectionView = MyCollectionView()
        myCollectionView.select = { [weak self] vc in
            self?.present(vc, animated: true)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 180, height: 240)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.delegate = myCollectionView
        collectionView.dataSource = myCollectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
    }

}
