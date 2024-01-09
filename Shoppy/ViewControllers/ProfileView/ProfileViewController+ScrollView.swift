//
//  ProfileViewController+ScrollView.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/01/2024.
//

import UIKit

extension ProfileViewController: UIScrollViewDelegate {
    
    func configureScrollView() {
        profileView.scrollView.delegate = self
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffset = scrollView.contentOffset.y
                
        // Check if scrolling up or down
        if currentContentOffset > 0 && currentContentOffset > lastContentOffset && tabBarVisible {
            // Scrolling down, hide the tab bar
            hideTabBar()
        } else if currentContentOffset < lastContentOffset && !tabBarVisible {
            // Scrolling up, show the tab bar
            showTabBar()
        }
        
        lastContentOffset = currentContentOffset
    }
    
    private func hideTabBar() {
        guard tabBarVisible else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.tabBarController?.tabBar.frame.origin.y += self.tabBarHeight
        }
        
        tabBarVisible = false
    }
    
    private func showTabBar() {
        guard !tabBarVisible else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.tabBarController?.tabBar.frame.origin.y -= self.tabBarHeight
        }
        
        tabBarVisible = true
    }
}
