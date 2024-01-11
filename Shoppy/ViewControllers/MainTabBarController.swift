//
//  MainTabBarController.swift
//  Shoppy
//
//  Created by Azoz Salah on 05/12/2023.
//

import UIKit

final class MainTabBarController: UITabBarController {
    let cartViewModel = CartViewModel()
    let ordersViewModel = OrdersViewModel()
    let listsViewModel = ListsViewModel()
    let wishListViewModel = WishListViewModel()
    
    var cartCount: Int = 0 {
        didSet {
            updateCartTabBarBadge()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .selectedTab
        
        bindToCartViewModel()
        
        let homeVC = makeHomeView()
        let categoriesVC = makeCategoriesView()
        let cartVC = makeCartView()
        let wishListVC = makeWishListView()
        let profileVC = makeProfileView()
        
        viewControllers = [
            makeNav(for: homeVC, title: "Home", icon: "house.fill", tag: 0),
            makeNav(for: categoriesVC, title: "Categories", icon: "square.grid.2x2.fill", tag: 1),
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
        //vc.navigationItem.largeTitleDisplayMode = .always
        
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = UIImage(
            systemName: icon,
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        nav.tabBarItem.tag = tag
        nav.tabBarItem.title = title
        nav.tabBarItem.badgeColor = .red
        
        return nav
    }
    
    func makeHomeView() -> HomeViewController {
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        
        let api = ProductsAPIServiceAdapter(api: ProductsAPI.shared)
        homeVC.service = api
        
        homeVC.cartViewModel = cartViewModel
        homeVC.listsViewModel = listsViewModel
        homeVC.wishListViewModel = wishListViewModel
        
        return homeVC
    }
    
    func makeCategoriesView() -> CollectionsViewController {
        let categoryVC = CollectionsViewController()
        categoryVC.title = "Categories"
        categoryVC.view.backgroundColor = .systemBackground
        categoryVC.navigationItem.largeTitleDisplayMode = .always
        let api = CollectionsAPIServiceAdapter(api: CollectionsAPI.shared)
        categoryVC.service = api
        categoryVC.cartViewModel = cartViewModel
        categoryVC.listsViewModel = listsViewModel
        categoryVC.wishListViewModel = wishListViewModel
        
        return categoryVC
    }
    
    func makeCartView() -> CartViewController {
        let cartVC = CartViewController(cartViewModel: cartViewModel)
        cartVC.ordersViewModel = ordersViewModel
        cartVC.title = "My Cart"
        cartVC.view.backgroundColor = .secondBackground
        
        return cartVC
    }
    
    func makeProfileView() -> ProfileViewController {
        let profileVC = ProfileViewController()
        profileVC.ordersViewModel = ordersViewModel
        profileVC.cartViewModel = cartViewModel
        profileVC.listsViewModel = listsViewModel
        profileVC.wishListViewModel = wishListViewModel
        return profileVC
    }
    
    func makeWishListView() -> WishListViewController {
        let wishListVC = WishListViewController()
        wishListVC.cartViewModel = cartViewModel
        wishListVC.viewModel = wishListViewModel
        wishListVC.listsViewModel = listsViewModel
        
        return wishListVC
    }
    
}
