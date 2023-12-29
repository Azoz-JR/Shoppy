//
//  OrdersCollectionViewDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 29/12/2023.
//

import UIKit

final class OrdersCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    var data: [Order] = []
    var parentController: ProfileViewPresenter?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderCollectionCell.identifier, for: indexPath) as? OrderCollectionCell {
            let order = data[indexPath.row]
            
            cell.configure(with: order)
            return cell
        }
        fatalError("Unable to dequeue OrderCollectionCell")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        parentController?.collectionViewDidScroll(scrollView)
    }
}
