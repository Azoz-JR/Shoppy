//
//  ProfileViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 06/12/2023.
//

import FirebaseAuth
import UIKit
import RxSwift

final class ProfileViewController: UIViewController, ProfileViewPresenter {
    var cartViewModel: CartViewModel?
    var listsViewModel: ListsViewModel?
    var wishListViewModel: WishListViewModel?
    var userViewModel: UserViewModel?
    
    var profileView = ProfileView()
    let ordersCollectionViewDelegate = OrdersCollectionViewDelegate()
    let listsCollectionViewDelegate = ListsCollectionViewDelegate()
    private var refreshControl = UIRefreshControl()
    
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
        bindToUser()
        configureOrdersCollection()
        configureListsCollection()
        configureProfileViewButtons()
        
        refresh()
    }
    
    private func updateUI() {
        updateOrders()
        updateLists()
    }
    
    func bindToUser() {
        userViewModel?.currentUser.subscribe(onNext: { [weak self] user in
            guard let user else {
                self?.profileView.usernameLabel.text = "Hello"
                return
            }
            
            self?.profileView.usernameLabel.text = "Hello, \(user.firstName?.capitalizedSentence ?? "UNKNOWN")"
        } )
        .disposed(by: disposeBag)
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
            
            let vc = OrdersViewController()
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
        cartViewModel?.getOrders()
        listsViewModel?.getLists() { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
}
