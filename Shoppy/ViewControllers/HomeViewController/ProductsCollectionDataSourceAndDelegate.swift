//
//  CollectionDataSourceAndDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import UIKit

final class ProductsCollectionDataSourceAndDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    var data: [ItemViewModel] = []
    var parentController: ParentControllerPresenter?
    var listsViewModel: ListsViewModel?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell {
            
            let product = data[indexPath.row]
            cell.configure(with: product)
            cell.liked = listsViewModel?.isLiked(product: product) ?? false
            
            cell.likeButtonHandler = { [weak self] in
                guard let listsViewModel = self?.listsViewModel else {
                    return
                }
                
                listsViewModel.likeProduct(product: product)
            }
            
            return cell
        }
        fatalError("Unable to dequeue ProductCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parentController?.itemSelected(at: indexPath)
    }
}
