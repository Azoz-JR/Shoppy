//
//  ProfileViewController+Orders.swift
//  Shoppy
//
//  Created by Azoz Salah on 11/01/2024.
//

import UIKit

extension ProfileViewController {
    func bindToOrders() {
        ordersViewModel?.orders.addObserver { [weak self] orders in
            guard let orders, let self else {
                self?.updateOrders()
                return
            }
            
            self.orders = orders
            self.ordersCollectionViewDelegate.data = orders
            self.updateOrders()
        }
    }
    
    func configureOrdersCollection() {
        ordersCollectionViewDelegate.data = orders
        ordersCollectionViewDelegate.parentController = self
        
        profileView.ordersCollection.dataSource = ordersCollectionViewDelegate
        profileView.ordersCollection.delegate = ordersCollectionViewDelegate
        profileView.ordersCollection.register(OrderCollectionCell.register(), forCellWithReuseIdentifier: OrderCollectionCell.identifier)
    }
    
    func updateOrders() {
        profileView.configureOrder(with: orders)
        reloadCollection()
    }
    
    func reloadCollection() {
        DispatchQueue.mainAsyncIfNeeded {
            UIView.transition(with: self.profileView.ordersCollection, duration: 0.3, options: .transitionCrossDissolve) {
                self.profileView.ordersCollection.reloadData()
            }
        }
    }
    
    func collectionViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = (scrollView.contentOffset.x / scrollView.frame.width).rounded()
        profileView.pageControl.currentPage = Int(pageIndex)
    }
    
}
