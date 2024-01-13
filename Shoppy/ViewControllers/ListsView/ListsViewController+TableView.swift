//
//  ListsViewController+TableView.swift
//  Shoppy
//
//  Created by Azoz Salah on 11/01/2024.
//

import UIKit

extension ListsViewController {
    func configuareTableView() {
        tableView.delegate = listsTableViewDelegate
        tableView.dataSource = listsTableViewDelegate
        
        listsTableViewDelegate.parentController = self
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(ListCell.register(), forCellReuseIdentifier: ListCell.identifier)
    }
    
    func reloadTableView() {
        DispatchQueue.mainAsyncIfNeeded {
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve) {
                self.tableView.reloadData()
            }
        }
    }
    
    func listSelected(at index: Int) {
        let list = listsTableViewDelegate.data[index]
        let vc = ListDetailViewController(list: list, cartViewModel: cartViewModel, listsViewModel: listsViewModel, wishListViewModel: wishListViewModel)
        
        show(vc, sender: self)
    }
    
    func listDeleted(at index: IndexPath) {
        let listTitle = listsTableViewDelegate.data[index.row].name
        showDeleteListAlert(title: listTitle, index: index)
    }
}
