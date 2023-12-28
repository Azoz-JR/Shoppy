//
//  ProfileViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    var ordersViewModel: OrdersViewModel?
    var productsViewModel: ProductsViewModel?
    
    let profileView = ProfileView()
    
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
        
        profileView.configureOrder(with: orders)
        profileView.configureList(with: lists)
        profileView.returnToHomeHandler = { [weak self] in
            self?.animateTabTransition(to: 0)
        }
    }
    
    func bindToOrders() {
        ordersViewModel?.orders.addObserver { [weak self] orders in
            guard let orders, let self else {
                self?.updateOrders()
                return
            }
            
            self.orders = orders
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
    }
    
    func updateLists() {
        guard let wishList = lists.first else {
            return
        }
        profileView.configureList(with: [wishList])
    }
    
}
