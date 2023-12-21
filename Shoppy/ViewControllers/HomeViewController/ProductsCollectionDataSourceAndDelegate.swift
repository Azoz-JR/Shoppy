//
//  CollectionDataSourceAndDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import UIKit

class ProductsCollectionDataSourceAndDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    var data: [ItemViewModel] = []
    var cartViewModel: CartViewModel?
    var parentController: HomeProductsPresenter?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell {
            
            let product = data[indexPath.row]
            cell.configure(with: product)
            
            cell.addToCartHandler = { [weak self] in
                guard let cartViewModel = self?.cartViewModel else {
                    return
                }
                cartViewModel.addProduct(product: product)
                self?.parentController?.showAlert()
            }
            
            return cell
        }
        fatalError("Unable to dequeue ProductCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parentController?.itemSelected(at: indexPath)
    }
}
