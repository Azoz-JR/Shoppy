//
//  HomeCollectionDataSourceAndDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 07/01/2024.
//

import UIKit

final class HomeCollectionDataSourceAndDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var data: [Section] = []
    var categories: [Category] = Category.allCases
    weak var parentController: HomeControllerPresenter?
    var wishListViewModel: WishListViewModel?

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Sales and Categories Sections
        if section < 2 {
            return 1
        }
        
        // Products Sections
        let count = data[section].items.count
        return  count > 2 ? 2 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Categories Section Doesn't have a header
        if section == 0 {
            return CGSize(width: 0, height: 0)
        }
        
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Categories Section
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 30)
        }
        
        // Sales Section
        if indexPath.section == 1 {
            return CGSize(width: collectionView.frame.width, height: 250)
        }
        
        // Products Sections
        return CGSize(width: 170, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Categories Section Doesn't have a header
        if indexPath.section == 0 {
            return UICollectionReusableView(frame: .zero)
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            if let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProductsCollectionReusableView.identifier,
                for: indexPath) as? ProductsCollectionReusableView {
                // Sales Section Doesn't need a seeMore button
                if indexPath.section == 1 {
                    headerView.configure(title: "SALES")
                    headerView.seeMoreButton.isHidden = true
                } else {
                    let sectionTitle = data[indexPath.section].title
                    headerView.configure(title: sectionTitle)
                    headerView.seeMoreButton.isHidden = false
                    
                    headerView.seeMoreHandler = { [weak self] in
                        self?.parentController?.setionSelected(at: indexPath)
                    }
                    
                }
                
                return headerView
            }
            fatalError("Unable to dequeue ProductsCollectionReusableView")
        }
        fatalError("There's no elementKindSectionHeader")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallCategoryCollectionCell.identifier, for: indexPath) as? SmallCategoryCollectionCell {
                
                cell.parentController = parentController

                return cell
            }
        }
        
        if indexPath.section == 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SalesCellView.identifier, for: indexPath) as? SalesCellView {
                
                cell.configure(with: salesURLs)

                return cell
            }
        }
        
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
        if indexPath.section < 2 {
            return
        }
        
        parentController?.itemSelected(at: indexPath)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        parentController?.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        parentController?.scrollViewDidScroll(scrollView)
    }
    
}
