//
//  SearchTableViewDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 08/01/2024.
//

import UIKit

class SearchTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var data: [ItemViewModel] = []
    var productsViewModel: ProductsViewModel?
    var listsViewModel: ListsViewModel?
    var parentController: SearchViewPresenter?

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell {
            let item = data[indexPath.row]
            
            cell.configure(with: item)
            
            return cell
        }
        fatalError("Unable to deque ListItemCellView")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentController?.itemSelected(at: indexPath)
    }
    
}
