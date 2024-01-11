//
//  ListsCollectionViewDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 11/01/2024.
//

import UIKit

final class ListsCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var data: [List] = []
    var parentController: ProfileViewPresenter?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionCell.identifier, for: indexPath) as? ListCollectionCell {
            let list = data[indexPath.row]
            
            cell.configure(with: list)
            return cell
        }
        fatalError("Unable to dequeue OrderCollectionCell")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        parentController?.listsCollectionViewDidScroll(scrollView)
    }
    
}
