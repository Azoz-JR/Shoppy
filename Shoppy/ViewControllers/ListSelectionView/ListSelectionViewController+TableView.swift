//
//  ListSelectionViewController+TableView.swift
//  Shoppy
//
//  Created by Azoz Salah on 11/01/2024.
//

import UIKit

extension ListSelectionViewController {
    func configuareTableView() {
        listsTableViewDelegate.parentController = self
        tableView.delegate = listsTableViewDelegate
        tableView.dataSource = listsTableViewDelegate
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(ListCell.register(), forCellReuseIdentifier: ListCell.identifier)
    }
    
    func listSelected(at index: Int) {
        guard !lists[index].contains(item: item) else {
            showAlert(title: "This item is already added to this list before.", dismiss: false)
            return
        }
        
        Task {
            await listsViewModel.add(item: item, at: index)
            showAlert(title: "Item added succesfully to \(lists[index].name)", dismiss: true)
        }
    }
    
    func reloadTableView() {
        DispatchQueue.mainAsyncIfNeeded {
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve) {
                self.tableView.reloadData()
            }
        }
    }
    
}
