//
//  ListDetailViewController+TableView.swift
//  Shoppy
//
//  Created by Azoz Salah on 11/01/2024.
//

import UIKit

extension ListDetailViewController {
    func configuareTableView() {
        tableView.delegate = listItemsTableViewDelegate
        tableView.dataSource = listItemsTableViewDelegate
        
        listItemsTableViewDelegate.data = list.items
        listItemsTableViewDelegate.parentController = self
        listItemsTableViewDelegate.cartViewModel = cartViewModel
        listItemsTableViewDelegate.listsViewModel = listsViewModel
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(ListItemCellView.register(), forCellReuseIdentifier: ListItemCellView.identifier)
    }
    
    func itemSelected(at index: IndexPath) {
        let product = list.items[index.row]
        select(product: product, cartViewModel: cartViewModel, listsViewModel: listsViewModel, wishListViewModel: wishListViewModel)
    }
    
    func itemDeleted(at index: IndexPath) {
        showDeleteItemAlert(index: index)
    }
    
    func deleteItem(index: IndexPath) {
        listItemsTableViewDelegate.data.remove(at: index.row)
        tableView.deleteRows(at: [index], with: .fade)
        
        let item = list.items[index.row]
        
        Task {
            await listsViewModel.remove(item: item, at: list)
        }
    }
    
    func showDeleteItemAlert(index: IndexPath) {
        let alert = UIAlertController(title: "Delete item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(index: index)
        }))
        
        present(alert, animated: true)
    }
}
