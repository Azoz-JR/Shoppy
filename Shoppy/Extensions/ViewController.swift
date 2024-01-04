//
//  ViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 28/12/2023.
//

import UIKit

extension UIViewController {
    func show(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        showDetailViewController(alert, sender: self)
    }
    
    func showAddedSuccessfulyAlert() {
        let alert = UIAlertController(title: "Success", message: "Product added to cart successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    func select(product: ItemViewModel, productsViewModel: ProductsViewModel, listsViewModel: ListsViewModel) {
        let vc = ProductViewController(product: product, productsViewModel: productsViewModel, listsViewModel: listsViewModel)
        //vc.modalPresentationStyle = .fullScreen
        //present(vc, animated: true)
        show(vc, sender: self)
    }
    
    func isHidingSearchBarOnScrolling(_ bool: Bool) {
        navigationItem.hidesSearchBarWhenScrolling = bool
    }
    
    func showOrederConfirmationMessage() {
        let alert = UIAlertController(title: "Thank you!", message: "Your order is submitted successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    func animateTabTransition(to index: Int) {
        if let tabBarController = self.tabBarController,
           let fromView = tabBarController.selectedViewController?.view,
           let toView = tabBarController.viewControllers?[index].view,
           index < tabBarController.viewControllers?.count ?? 0 {
            
            // Set the new view controller as the selected one
            tabBarController.selectedIndex = index
            
            // Add the new view controller's view to the tab bar controller's view
            fromView.superview?.addSubview(toView)
            
            // Set the initial position of the toView
            toView.frame = CGRect(x: fromView.frame.origin.x + fromView.frame.size.width,
                                  y: fromView.frame.origin.y,
                                  width: fromView.frame.size.width,
                                  height: fromView.frame.size.height)
            
            // Animate the transition
            UIView.animate(withDuration: 0.3, animations: {
                fromView.frame = CGRect(x: fromView.frame.origin.x - fromView.frame.size.width,
                                        y: fromView.frame.origin.y,
                                        width: fromView.frame.size.width,
                                        height: fromView.frame.size.height)
                
                toView.frame = CGRect(x: toView.frame.origin.x - fromView.frame.size.width,
                                      y: toView.frame.origin.y,
                                      width: toView.frame.size.width,
                                      height: toView.frame.size.height)
            }) { (finished) in
                // Remove the fromView from superview after the animation
                fromView.removeFromSuperview()
            }
        }
    }
    
    func showAlert(title: String, dismiss: Bool) {
        let alert = UIAlertController(title: "", message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            if dismiss {
                self?.dismiss(animated: true)
            }
        }))
        present(alert, animated: true)
    }
    
    func showCreateListView(listsViewModel: ListsViewModel?) {
        let vc = CreateListView()
        vc.listsViewModel = listsViewModel
        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [
            .custom { _ in
                return 250
            }
        ]
        present(vc, animated: true)
    }
    
}
