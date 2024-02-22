//
//  MainTabBarController.swift
//  Shoppy
//
//  Created by Azoz Salah on 05/12/2023.
//

import RxSwift
import UIKit


final class MainTabBarController: UITabBarController {
    let cartViewModel = CartViewModel()
    let listsViewModel = ListsViewModel()
    let wishListViewModel = WishListViewModel()
    let userViewModel = UserViewModel()
    
    // Side Profile
    let sideProfileView = SideProfile()
    let sideProfileTableDelegate = SideProfileTableViewDelegate()
    var isProfileVisible = false
    let swipeThreshold: CGFloat = UIScreen.main.bounds.width / 2.0
    var initialTranslationX: CGFloat = 0.0
    
    let disposeBag = DisposeBag()
    
    var cartCount: Int = 0 {
        didSet {
            updateCartTabBarBadge()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        sideProfileView.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(sideProfileView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .selectedTab
                
        bindToCartViewModel()
        bindToUser()
        
        configureSideProfile()
        configureSideProfileTableView()
        
        let homeVC = makeHomeView()
        let categoriesVC = makeCollectionsView()
        let cartVC = makeCartView()
        let wishListVC = makeWishListView()
        let profileVC = makeProfileView()
        
        viewControllers = [
            makeNav(for: homeVC, title: "Home", icon: "house.fill", tag: 0),
            makeNav(for: categoriesVC, title: "Collections", icon: "square.grid.2x2.fill", tag: 1),
            makeNav(for: cartVC, title: "Cart", icon: "cart.fill", tag: 2),
            makeNav(for: wishListVC, title: "Wish list", icon: "heart.fill", tag: 3),
            makeNav(for: profileVC, title: "You", icon: "person.fill", tag: 4)
        ]
    }
    
    func updateCartTabBarBadge() {
        let cartTabBar = tabBar.items?[2]
        
        guard cartCount > 0 else {
            cartTabBar?.badgeValue = nil
            return
        }
        cartTabBar?.badgeValue = "\(cartCount)"
    }
    
    func bindToCartViewModel() {
        cartViewModel.cartCount.addObserver { [weak self] count in
            guard let self = self, let count = count else {
                return
            }
            self.cartCount = count
        }
    }
    
    private func makeNav(for vc: UIViewController, title: String, icon: String, tag: Int) -> UIViewController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = UIImage(
            systemName: icon,
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        nav.tabBarItem.tag = tag
        nav.tabBarItem.title = title
        nav.tabBarItem.badgeColor = .red
        //nav.navigationBar.tintColor = .navBarTint
                
        return nav
    }
    
    func makeHomeView() -> HomeViewController {
        let homeVC = HomeViewController()
        homeVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(showProfile))
        
        let api = ProductsAPIServiceAdapter(api: ProductsAPI.shared)
        homeVC.service = api
        
        homeVC.cartViewModel = cartViewModel
        homeVC.listsViewModel = listsViewModel
        homeVC.wishListViewModel = wishListViewModel
        
        return homeVC
    }
    
    func makeCollectionsView() -> CollectionsViewController {
        let collectionsVC = CollectionsViewController()
        collectionsVC.view.backgroundColor = .systemBackground
        collectionsVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(showProfile))
        let api = CollectionsAPIServiceAdapter(api: CollectionsAPI.shared)
        collectionsVC.service = api
        collectionsVC.cartViewModel = cartViewModel
        collectionsVC.listsViewModel = listsViewModel
        collectionsVC.wishListViewModel = wishListViewModel
        
        return collectionsVC
    }
    
    func makeCartView() -> CartViewController {
        let cartVC = CartViewController(cartViewModel: cartViewModel, userViewModel: userViewModel)
        cartVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(showProfile))
        cartVC.view.backgroundColor = .secondBackground
        
        return cartVC
    }
    
    func makeProfileView() -> ProfileViewController {
        let profileVC = ProfileViewController()
        profileVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(showProfile))
        profileVC.cartViewModel = cartViewModel
        profileVC.listsViewModel = listsViewModel
        profileVC.wishListViewModel = wishListViewModel
        profileVC.userViewModel = userViewModel
                
        return profileVC
    }
    
    func makeWishListView() -> WishListViewController {
        let wishListVC = WishListViewController()
        wishListVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(showProfile))
        wishListVC.cartViewModel = cartViewModel
        wishListVC.viewModel = wishListViewModel
        wishListVC.listsViewModel = listsViewModel
        
        return wishListVC
    }
    
}
