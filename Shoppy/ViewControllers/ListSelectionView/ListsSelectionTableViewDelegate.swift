//
//  ListsSelectionTableViewDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 04/01/2024.
//

import UIKit

class ListsSelectionTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    var data: [List] = []
    var parentController: ListsControllerPresenter?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell {
            cell.accessoryType = .none
            
            let list = data[indexPath.row]
            cell.configure(with: list)

            return cell
        }
        fatalError("Unable to dequeue ListCell!")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentController?.listSelected(at: indexPath.row)
    }
    
}
