//
//  ProfileViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import UIKit

final class ProfileViewController: UIViewController, ProfileViewPresenter {
    var ordersViewModel: OrdersViewModel?
    var productsViewModel: ProductsViewModel?
    
    let profileView = ProfileView()
    let ordersCollectionViewDelegate = OrdersCollectionViewDelegate()
    
    var orders: [Order] = []
    var lists: [List] = []
    
    override func loadView() {
        super.loadView()
        
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .systemBackground
        
        bindToOrders()
        bindToWishList()
        
        configureOrdersCollection()
        profileView.configureOrder(with: orders)
        profileView.configureList(with: lists)
        configureProfileViewButtons()
    }
    
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
    
    func bindToWishList() {
        productsViewModel?.likedProducts.addObserver { [weak self] items in
            guard let items = items, !items.isEmpty else {
                self?.updateLists()
                return
            }
            
            self?.lists = [List(name: "Wish list", items: items)]
            self?.updateLists()
        }
    }
    
    func updateOrders() {
        profileView.configureOrder(with: orders)
        reloadCollection()
    }
    
    func updateLists() {
        guard let wishList = lists.first else {
            return
        }
        profileView.configureList(with: [wishList])
    }
    
    func configureProfileViewButtons() {
        profileView.returnToHomeHandler = { [weak self] in
            self?.animateTabTransition(to: 0)
        }
        
        profileView.seeAllOrdersHandler = { [weak self] in
            guard let self else {
                return
            }
            
            let vc = OrdersViewController(orders: self.orders)
            self.show(vc, sender: self)
        }
    }
    
    func configureOrdersCollection() {
        ordersCollectionViewDelegate.data = orders
        ordersCollectionViewDelegate.parentController = self
        
        profileView.ordersCollection.dataSource = ordersCollectionViewDelegate
        profileView.ordersCollection.delegate = ordersCollectionViewDelegate
        profileView.ordersCollection.register(OrderCollectionCell.register(), forCellWithReuseIdentifier: OrderCollectionCell.identifier)
    }
    
    private func reloadCollection() {
        DispatchQueue.mainAsyncIfNeeded {
            self.profileView.ordersCollection.reloadData()
        }
    }
    
    func collectionViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = (scrollView.contentOffset.x / scrollView.frame.width).rounded()
        profileView.pageControl.currentPage = Int(pageIndex)
    }
    
}
