//
//  HomeCollectionDataSourceAndDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 07/01/2024.
//

import UIKit

final class HomeCollectionDataSourceAndDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var data: [Section] = []
    weak var parentController: HomeControllerPresenter?
    var wishListViewModel: WishListViewModel?

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = data[section].items.count
        return  count > 2 ? 2 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            if let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProductsCollectionReusableView.identifier,
                for: indexPath) as? ProductsCollectionReusableView {
                
                let sectionTitle = data[indexPath.section].title
                headerView.configure(title: sectionTitle)
                
                headerView.seeMoreHandler = { [weak self] in
                    self?.parentController?.setionSelected(at: indexPath)
                }
                
                return headerView
            }
            fatalError("Unable to dequeue ProductsCollectionReusableView")
        }
        fatalError("There's no elementKindSectionHeader")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell {
            
            let product = data[indexPath.section].items[indexPath.row]
            cell.configure(with: product)
            cell.liked = wishListViewModel?.isLiked(product: product) ?? false
            
            cell.likeButtonHandler = { [weak self] in
                guard let wishListViewModel = self?.wishListViewModel else {
                    return
                }
                
                wishListViewModel.likeProduct(product: product)
            }
            
            return cell
        }
        fatalError("Unable to dequeue ProductCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parentController?.itemSelected(at: indexPath)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        parentController?.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        parentController?.scrollViewDidScroll(scrollView)
    }
    
}
