//
//  ProfileViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import UIKit
import RxSwift

final class ProfileViewController: UIViewController, ProfileViewPresenter {
    var cartViewModel: CartViewModel?
    var listsViewModel: ListsViewModel?
    var wishListViewModel: WishListViewModel?
    
    let profileView = ProfileView()
    let ordersCollectionViewDelegate = OrdersCollectionViewDelegate()
    let listsCollectionViewDelegate = ListsCollectionViewDelegate()
    private var refreshControl = UIRefreshControl()
    
    var orders: [Order] = []
    var lists: [List] = []
    let disposeBag = DisposeBag()
    
    var tabBarVisible = true
    var lastContentOffset: CGFloat = 0
    
    override func loadView() {
        super.loadView()
        
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureScrollView()
        bindToOrders()
        bindToLists()
        configureOrdersCollection()
        configureListsCollection()
        configureProfileViewButtons()
        
        refresh()
    }
    
    private func updateUI() {
        updateOrders()
        updateLists()
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
            guard let self, let cartViewModel = self.cartViewModel, let listsViewModel, let wishListViewModel else {
                return
            }
            
            let vc = ListsViewController(cartViewModel: cartViewModel, listsViewModel: listsViewModel, wishListViewModel: wishListViewModel)
            self.show(vc, sender: self)
        }
    }
    
    func configureNavBar() {
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .navBarTint
        
        let name = UIButton(type: .system)
        name.setTitle("Shoppy", for: .normal)
        name.tintColor = .label
        name.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        
        let label = UIBarButtonItem(customView: name)
        navigationItem.leftBarButtonItem = label
        
        //Refresh View
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .myGreen
        profileView.scrollView.refreshControl = refreshControl
    }
    
    @objc func refresh() {
        cartViewModel?.getOrders(userId: "9Cvmx2WJsVBARTmaQy6Q")
        listsViewModel?.getLists(userId: "9Cvmx2WJsVBARTmaQy6Q") { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
}
