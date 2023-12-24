//
//  CollectionDataSourceAndDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import UIKit

class ProductsCollectionDataSourceAndDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    var data: [ItemViewModel] = []
    var productsViewModel: ProductsViewModel?
    var parentController: ParentControllerPresenter?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell {
            
            let product = data[indexPath.row]
            cell.configure(with: product)
            cell.liked = productsViewModel?.isLiked(product: product) ?? false
            
            cell.addToCartHandler = { [weak self] in
                guard let productsViewModel = self?.productsViewModel else {
                    return
                }
                productsViewModel.addProduct(product: product)
                self?.parentController?.showAlert()
            }
            
            cell.likeButtonHandler = { [weak self] in
                guard let productsViewModel = self?.productsViewModel else {
                    return
                }
                
                productsViewModel.likeProduct(product: product)
            }
            
            return cell
        }
        fatalError("Unable to dequeue ProductCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parentController?.itemSelected(at: indexPath)
    }
}
