//
//  OrderCollectionDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 29/12/2023.
//

import UIKit

class OrderCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var data: [ItemViewModel] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifier, for: indexPath) as? ItemCell {
            let item = data[indexPath.row]
            cell.configure(with: item)
            
            return cell
        }
        fatalError("Unable to dequeue ProductCell!")
    }
    
}
