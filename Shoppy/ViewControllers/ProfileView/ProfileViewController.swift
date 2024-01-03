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
        
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = .navigationBar
//        appearance.shadowColor = .clear
//        
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationController?.navigationBar.standardAppearance = appearance
        
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
            let vc = CreateListView()
            vc.listsViewModel = self?.listsViewModel
            vc.modalPresentationStyle = .pageSheet
            vc.sheetPresentationController?.detents = [
                .custom { _ in
                    return 280
                }
            ]
            
            self?.present(vc, animated: true)
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
            self.profileView.ordersCollection.reloadData()
        }
    }
    
    func collectionViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = (scrollView.contentOffset.x / scrollView.frame.width).rounded()
        profileView.pageControl.currentPage = Int(pageIndex)
    }
    
}
