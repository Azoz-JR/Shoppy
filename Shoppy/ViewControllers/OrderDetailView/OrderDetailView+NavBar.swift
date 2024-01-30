//
//  OrderDetailView+NavBar.swift
//  Shoppy
//
//  Created by Azoz Salah on 25/01/2024.
//

import UIKit

extension OrderDetailViewController: ScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffset = scrollView.contentOffset.y + view.safeAreaInsets.top
                
        // Check if scrolling up or down
        if currentContentOffset > 1 && currentContentOffset > lastContentOffset && navBarVisible {
            // Scrolling down, hide the tab bar
            hideNavBar()
        } else if currentContentOffset < lastContentOffset && !navBarVisible {
            // Scrolling up, show the tab bar
            showNavBar()
        }
        
        lastContentOffset = currentContentOffset
    }
    
    func hideNavBar() {
        guard navBarVisible else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.navigationBar.isHidden = true
        }
        
        navBarVisible = false
    }
    
    func showNavBar() {
        guard !navBarVisible else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.navigationBar.isHidden = false
        }
        
        navBarVisible = true
    }
}
