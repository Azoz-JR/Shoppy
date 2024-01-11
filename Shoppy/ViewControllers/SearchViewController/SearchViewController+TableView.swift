//
//  SearchViewController+TableView.swift
//  Shoppy
//
//  Created by Azoz Salah on 11/01/2024.
//

import UIKit

extension SearchViewController: SearchViewPresenter {
    func configuareTableView() {
        tableView.delegate = searchTableViewDelegate
        tableView.dataSource = searchTableViewDelegate
        tableView.keyboardDismissMode = .onDrag
        
        searchTableViewDelegate.parentController = self
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(SearchTableViewCell.register(), forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve) {
                self.tableView.reloadData()
            }
        }
    }
    
    func itemSelected(at index: IndexPath) {
        guard let cartViewModel, let listsViewModel, let wishListViewModel else {
            return
        }
        
        let product = searchTableViewDelegate.data[index.row]
        
        select(product: product, cartViewModel: cartViewModel, listsViewModel: listsViewModel, wishListViewModel: wishListViewModel)
    }
}
