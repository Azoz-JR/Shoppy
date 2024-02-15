//
//  ListItemsTableViewDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 05/01/2024.
//

import UIKit

class ListItemsTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var data: [ItemModel] = []
    var cartViewModel: CartViewModel?
    var listsViewModel: ListsViewModel?
    var parentController: ListDetailViewPresenter?

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ListItemCellView.identifier, for: indexPath) as? ListItemCellView {
            let item = data[indexPath.row]
            
            cell.configure(with: item)
            
            cell.addToCartHandler = { [weak self] in
                guard let cartViewModel = self?.cartViewModel else {
                    return
                }
                
                cartViewModel.addProduct(product: item) { error in
                    self?.parentController?.showAlert(error: error)
                }
                
            }
            
            return cell
        }
        fatalError("Unable to dequeue ListItemCellView")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentController?.itemSelected(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                
        let delete = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            
            self?.parentController?.itemDeleted(at: indexPath)
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
    
}
