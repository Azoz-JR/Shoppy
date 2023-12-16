//
//  MyCollectionView.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import UIKit

class MyCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var data: [Product] = []
    var select: ((Product) -> Void)?
    var cartViewModel: CartViewModel?
    var showSuccessAlert: (() -> Void)?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell {
            
            let product = data[indexPath.row]
            cell.configure(with: product)
            
            cell.addToCartHandler = { [weak self] in
                guard let cartViewModel = self?.cartViewModel else {
                    return
                }
                cartViewModel.addProduct(product: product.toProductViewModel())
                self?.showSuccessAlert?()
            }
            
            return cell
        }
        fatalError("Unable to dequeue ProductCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = data[indexPath.row]
        select?(product)
    }
    
}
