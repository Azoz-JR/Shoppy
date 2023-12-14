//
//  MainTabBarController.swift
//  Shoppy
//
//  Created by Azoz Salah on 05/12/2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    let cartViewModel = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.backgroundColor = .systemBackground
        
        
        let homeVC = makeHomeView()
        let categoriesVC = makeCategoriesView()
        let cartVC = makeCartView()
        let profileVC = ProfileViewController()
        
        viewControllers = [
            makeNav(for: homeVC, title: "Home", icon: "house", tag: 0),
            makeNav(for: categoriesVC, title: "Categories", icon: "square.grid.2x2", tag: 1),
            makeNav(for: cartVC, title: "Cart", icon: "cart", tag: 2),
            makeNav(for: profileVC, title: "Profile", icon: "person", tag: 3)
        ]
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
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }
    
    func makeHomeView() -> HomeViewController {
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        homeVC.navigationItem.largeTitleDisplayMode = .always
        homeVC.view.backgroundColor = .secondBackground
        
        let api = ProductsAPIProductsServiceAdapter(api: ProductsAPI.shared, category: .skincare)
        homeVC.service = api
        
        return homeVC
    }
    
    func makeCategoriesView() -> CategoriesViewController {
        let categoryVC = CategoriesViewController()
        categoryVC.title = "Categories"
        categoryVC.view.backgroundColor = .secondBackground
        categoryVC.navigationItem.largeTitleDisplayMode = .always
        return categoryVC
    }
    
    func makeCartView() -> CartViewController {
        let cartVC = CartViewController(viewModel: cartViewModel)
        cartVC.title = "My Cart"
        cartVC.view.backgroundColor = .secondBackground
        
        return cartVC
    }
    
}
