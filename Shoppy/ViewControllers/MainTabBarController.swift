//
//  MainTabBarController.swift
//  Shoppy
//
//  Created by Azoz Salah on 05/12/2023.
//

import UIKit

final class MainTabBarController: UITabBarController {
    let productsViewModel = ProductsViewModel()
    let ordersViewModel = OrdersViewModel()
    
    var cartCount: Int = 0 {
        didSet {
            updateCartTabBarBadge()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        bindToProductsViewModel()
        
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
            makeNav(for: profileVC, title: "You", icon: "person", tag: 4)
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
    
    func bindToProductsViewModel() {
        productsViewModel.cartCount.addObserver { [weak self] count in
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
//        nav.navigationBar.prefersLargeTitles = true
//        nav.navigationItem.largeTitleDisplayMode = .always
        nav.translucentTabAndNavigationBars()
        return nav
    }
    
    func makeHomeView() -> HomeViewController {
        let homeVC = HomeViewController()
        homeVC.title = "Home"
//        homeVC.navigationItem.largeTitleDisplayMode = .always
//        homeVC.navigationController?.navigationBar.prefersLargeTitles = true
        
        let api = ProductsAPIServiceAdapter(api: ProductsAPI.shared)
        homeVC.service = api
        
        homeVC.productsViewModel = productsViewModel
        
        return homeVC
    }
    
    func makeCategoriesView() -> CategoriesViewController {
        let categoryVC = CategoriesViewController()
        categoryVC.title = "Categories"
        categoryVC.view.backgroundColor = .systemBackground
        categoryVC.navigationItem.largeTitleDisplayMode = .always
        
        let api = CollectionsAPIServiceAdapter(api: CollectionsAPI.shared)
        categoryVC.service = api
                
        categoryVC.productsViewModel = productsViewModel
        
        return categoryVC
    }
    
    func makeCartView() -> CartViewController {
        let cartVC = CartViewController(viewModel: productsViewModel, ordersViewModel: ordersViewModel)
        cartVC.title = "My Cart"
        cartVC.view.backgroundColor = .secondBackground
        
        return cartVC
    }
    
    func makeProfileView() -> ProfileViewController {
        let profileVC = ProfileViewController()
        profileVC.ordersViewModel = ordersViewModel
        profileVC.productsViewModel = productsViewModel
        return profileVC
    }
    
    func makeWishListView() -> WishListViewController {
        let wishListVC = WishListViewController()
        wishListVC.productsViewModel = productsViewModel
        
        return wishListVC
    }
    
}
