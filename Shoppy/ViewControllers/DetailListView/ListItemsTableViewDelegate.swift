//
//  ListItemsTableViewDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 05/01/2024.
//

import UIKit

class ListItemsTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var data: [ItemViewModel] = []
    var productsViewModel: ProductsViewModel?
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
                guard let productsViewModel = self?.productsViewModel else {
                    return
                }
                productsViewModel.addProduct(product: item)
                self?.parentController?.showAlert()
            }
            
            cell.optionsHandler = { [weak self] in
                
            }
            
            return cell
        }
        fatalError("Unable to deque ListItemCellView")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentController?.itemSelected(at: indexPath)
    }
    
}
