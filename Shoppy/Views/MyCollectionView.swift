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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell {
            cell.configure(with: data[indexPath.row])
            return cell
        }
        fatalError("Unable to dequeue ProductCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = data[indexPath.row]
        select?(product)
    }

}
