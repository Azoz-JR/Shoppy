//
//  CategoriesCollectionDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import UIKit

final class CategoriesCollectionDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var data: [Category] = Category.allCases
    weak var parentController: HomeCategoriesPresenter?
    
    
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
