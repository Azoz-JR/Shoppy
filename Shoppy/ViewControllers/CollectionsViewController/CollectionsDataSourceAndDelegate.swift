//
//  CollectionsDataSourceAndDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import UIKit

final class CollectionsDataSourceAndDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var data: [ItemViewModel] = []
    var parentController: CollectionsPresenter?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as? CollectionCell {
            cell.configure(with: data[indexPath.row])
            return cell
        }
        fatalError("Unable to dequeue CategoryCell")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parentController?.categorySelected(at: indexPath)
    }
}

