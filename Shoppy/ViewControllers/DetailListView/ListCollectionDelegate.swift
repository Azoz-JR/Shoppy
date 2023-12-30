//
//  ListCollectionDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 30/12/2023.
//

import UIKit

class ListCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var data: [ItemViewModel] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell {
            let item = data[indexPath.row]
            cell.configure(with: item)
            
            return cell
        }
        fatalError("Unable to dequeue ProductCell!")
    }
    
}
