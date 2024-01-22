//
//  MainTabBar+SideProfileTableView.swift
//  Shoppy
//
//  Created by Azoz Salah on 22/01/2024.
//

import UIKit

extension MainTabBarController: MainTabBarPresenter {
    
    func configureSideProfileTableView() {
        sideProfileTableDelegate.parentController = self
        
        sideProfileView.tableView.delegate = sideProfileTableDelegate
        sideProfileView.tableView.dataSource = sideProfileTableDelegate
        sideProfileView.tableView.keyboardDismissMode = .onDrag
        sideProfileView.tableView.backgroundColor = .clear
        sideProfileView.tableView.round(10)
        
        registerCell()
    }
    
    func registerCell() {
        sideProfileView.tableView.register(SideProfileCell.register(), forCellReuseIdentifier: SideProfileCell.identifier)
    }
    
    func itemSelected(item: SideProfileCellType) {
        switch item {
        case .wishList:
            let wishListVC = WishListViewController()
            wishListVC.title = "Wish list"
            wishListVC.refreshControl = nil
            wishListVC.cartViewModel = cartViewModel
            wishListVC.viewModel = wishListViewModel
            wishListVC.listsViewModel = listsViewModel
            wishListVC.modalPresentationStyle = .pageSheet
            
            let nav = UINavigationController(rootViewController: wishListVC)
            nav.navigationBar.tintColor = .navBarTint
            show(nav, sender: self)
            
        case .orders:
            let ordersVC = OrdersViewController()
            ordersVC.cartViewModel = cartViewModel
            
            let nav = UINavigationController(rootViewController: ordersVC)
            nav.navigationBar.tintColor = .navBarTint
            show(nav, sender: self)
                        
        case .lists:
            let listsVC = ListsViewController(cartViewModel: cartViewModel, listsViewModel: listsViewModel, wishListViewModel: wishListViewModel)
            
            let nav = UINavigationController(rootViewController: listsVC)
            nav.navigationBar.tintColor = .navBarTint
            show(nav, sender: self)
        }
        
    }
    
}
