//
//  SmallCategoryCollectionCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 02/02/2024.
//

import UIKit

class SmallCategoryCollectionCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var categoriesCollectionView: UICollectionView!
    
    var data: [Category] = Category.allCases
    weak var parentController: HomeControllerPresenter?
    
    static let identifier = "SmallCategoryCollectionCell"
    
    static func register() -> UINib {
        UINib(nibName: "SmallCategoryCollectionCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCategoriesCollection()
    }
    
    func configureCategoriesCollection() {
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(SmallCategoryCell.register(), forCellWithReuseIdentifier: SmallCategoryCell.identifier)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallCategoryCell.identifier, for: indexPath) as? SmallCategoryCell {
            cell.configure(with: data[indexPath.row])
            
            return cell
        }
        fatalError("Unable to dequeue CategoryCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parentController?.categorySelected(at: indexPath)
    }

}
