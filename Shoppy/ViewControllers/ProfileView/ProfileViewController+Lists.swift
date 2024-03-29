//
//  ProfileViewController+Lists.swift
//  Shoppy
//
//  Created by Azoz Salah on 11/01/2024.
//

import UIKit
import RxSwift

extension ProfileViewController {
    func bindToLists() {
        listsViewModel?.lists.subscribe { [weak self] lists in
            guard let self else {
                self?.updateLists()
                return
            }
            
            self.listsCollectionViewDelegate.data = lists
            self.updateLists()
        }
        .disposed(by: disposeBag)
        
        
        listsViewModel?.error.subscribe(onNext: { [weak self] error in
            self?.show(error: error)
        })
        .disposed(by: disposeBag)
    }
    
    func configureListsCollection() {
        listsCollectionViewDelegate.parentController = self
        
        profileView.listsCollection.dataSource = listsCollectionViewDelegate
        profileView.listsCollection.delegate = listsCollectionViewDelegate
        profileView.listsCollection.register(ListCollectionCell.register(), forCellWithReuseIdentifier: ListCollectionCell.identifier)
    }
    
    func updateLists() {
        profileView.configureLists(with: listsCollectionViewDelegate.data)
        reloadListsCollection()
    }
    
    func reloadListsCollection() {
        DispatchQueue.mainAsyncIfNeeded {
            UIView.transition(with: self.profileView.listsCollection, duration: 0.3, options: .transitionCrossDissolve) {
                self.profileView.listsCollection.reloadData()
            }
        }
    }
    
    func listsCollectionViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = (scrollView.contentOffset.x / scrollView.frame.width).rounded()
        profileView.listsPageControl.currentPage = Int(pageIndex)
    }
    
}
