//
//  CategoryViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let categories: [Category] = Category.allCases
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 180, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        // Customize the collection view appearance if needed
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        title = "Categories"
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            // Collection View Constraints
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell {
            cell.configure(with: categories[indexPath.row])
            return cell
        }
        fatalError("Unable to dequeue CategoryCell")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CategoryViewController()
        let category = categories[indexPath.row]
        vc.category = category
        
        let api = ProductsAPIProductsServiceAdapter(api: ProductsAPI.shared, category: category)
        vc.service = api
        
        show(vc, sender: self)
    }
    
}
