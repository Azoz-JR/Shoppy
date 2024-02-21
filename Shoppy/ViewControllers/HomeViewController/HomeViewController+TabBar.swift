//
//  HomeViewController+TabBar.swift
//  Shoppy
//
//  Created by Azoz Salah on 10/01/2024.
//

import UIKit

extension HomeViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffset = scrollView.contentOffset.y + collectionView.contentInset.top
                
        // Check if scrolling up or down
        if currentContentOffset > 1 && currentContentOffset > lastContentOffset && tabBarVisible {
            // Scrolling down, hide the tab bar
            hideTabBar()
        } else if currentContentOffset < lastContentOffset && !tabBarVisible {
            // Scrolling up, show the tab bar
            showTabBar()
        }
        
        lastContentOffset = currentContentOffset
    }
    
    func hideTabBar() {
        guard tabBarVisible else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.tabBarController?.tabBar.frame.origin.y += self.tabBarHeight
        }
        
        tabBarVisible = false
    }
    
    func showTabBar() {
        guard !tabBarVisible else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.tabBarController?.tabBar.frame.origin.y -= self.tabBarHeight
        }
        
        tabBarVisible = true
    }
    
}

