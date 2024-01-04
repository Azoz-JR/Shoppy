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
    var listsViewModel: ListsViewModel?
    
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
        
        configureNavBar()
        
        let name = UIButton(type: .system)
        name.setTitle("Shoppy", for: .normal)
        name.tintColor = .label
        name.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        
        let label = UIBarButtonItem(customView: name)
        
        navigationItem.leftBarButtonItem = label
        
        bindToOrders()
        bindToLists()
        configureOrdersCollection()
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
    
    func bindToLists() {
        listsViewModel?.lists.addObserver { [weak self] lists in
            guard let lists, !lists.isEmpty else {
                self?.updateLists()
                return
            }
            
            self?.lists = lists
            self?.updateLists()
        }
    }
    
    private func updateUI() {
        updateOrders()
        updateLists()
    }
    
    func updateOrders() {
        profileView.configureOrder(with: orders)
        reloadCollection()
    }
    
    func updateLists() {
        profileView.configureLists(with: lists)
    }
    
    func configureProfileViewButtons() {
        profileView.returnToHomeHandler = { [weak self] in
            self?.animateTabTransition(to: 0)
        }
        
        profileView.createListHandler = { [weak self] in
            guard let listsViewModel = self?.listsViewModel else {
                return
            }
            self?.showCreateListView(listsViewModel: listsViewModel)
        }
        
        profileView.seeAllOrdersHandler = { [weak self] in
            guard let self else {
                return
            }
            
            let vc = OrdersViewController(orders: self.orders)
            self.show(vc, sender: self)
        }
        
        profileView.seeAllListsHandler = { [weak self] in
            guard let self, let productsViewModel = self.productsViewModel, let listsViewModel else {
                return
            }
            let vc = ListsViewController(productsViewModel: productsViewModel, listsViewModel: listsViewModel)
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
            UIView.transition(with: self.profileView.ordersCollection, duration: 0.3, options: .transitionCrossDissolve) {
                self.profileView.ordersCollection.reloadData()
            }
        }
    }
    
    func collectionViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = (scrollView.contentOffset.x / scrollView.frame.width).rounded()
        profileView.pageControl.currentPage = Int(pageIndex)
    }
    
    func configureNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.backgroundColor = .clear
        scrollAppearance.shadowColor = .clear
        
        navigationController?.navigationBar.scrollEdgeAppearance = scrollAppearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
}
