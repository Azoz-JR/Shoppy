//
//  MainTabBarController.swift
//  Shoppy
//
//  Created by Azoz Salah on 05/12/2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    let cartViewModel = CartViewModel()
    
    var cartCount: Int = 0 {
        didSet {
            updateCartTabBarBadge()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        bindToCartViewModel()
        
        let homeVC = makeHomeView()
        let categoriesVC = makeCategoriesView()
        let cartVC = makeCartView()
        let wishListVC = makeWishListView()
        
        viewControllers = [
            makeNav(for: homeVC, title: "Home", icon: "house.fill", tag: 0),
            makeNav(for: categoriesVC, title: "Categories", icon: "square.grid.2x2.fill", tag: 1),
            makeNav(for: cartVC, title: "Cart", icon: "cart.fill", tag: 2),
            makeNav(for: wishListVC, title: "Wish list", icon: "heart.fill", tag: 3)
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
        cartViewModel.cartCount.bind { [weak self] count in
            guard let self = self, let count = count else {
                return
            }
            self.cartCount = count
        }
    }
    
    private func makeNav(for vc: UIViewController, title: String, icon: String, tag: Int) -> UIViewController {
        vc.navigationItem.largeTitleDisplayMode = .always
        
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = UIImage(
            systemName: icon,
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        nav.tabBarItem.tag = tag
        nav.tabBarItem.title = title
        nav.tabBarItem.badgeColor = .red
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationItem.largeTitleDisplayMode = .always
        return nav
    }
    
    func makeHomeView() -> HomeViewController {
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        homeVC.navigationItem.largeTitleDisplayMode = .always
        homeVC.navigationController?.navigationBar.prefersLargeTitles = true
        
        let api = ProductsAPIServiceAdapter(api: ProductsAPI.shared)
        homeVC.service = api
        
        homeVC.cartViewModel = cartViewModel
        
        return homeVC
    }
    
    func makeCategoriesView() -> CategoriesViewController {
        let categoryVC = CategoriesViewController()
        categoryVC.title = "Categories"
        categoryVC.view.backgroundColor = .secondBackground
        categoryVC.navigationItem.largeTitleDisplayMode = .always
        
        let api = CollectionsAPIServiceAdapter(api: CollectionsAPI.shared)
        categoryVC.service = api
                
        categoryVC.cartViewModel = cartViewModel
        
        return categoryVC
    }
    
    func makeCartView() -> CartViewController {
        let cartVC = CartViewController(viewModel: cartViewModel)
        cartVC.title = "My Cart"
        cartVC.view.backgroundColor = .secondBackground
        
        return cartVC
    }
    
    func makeProfileView() -> ProfileViewController {
        let profileVC = ProfileViewController()
        return profileVC
    }
    
    func makeWishListView() -> WishListViewController {
        let wishListVC = WishListViewController()
        wishListVC.cartViewModel = cartViewModel
        
        return wishListVC
    }
    
}
