//
//  ListsTableViewDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 29/12/2023.
//

import UIKit

class ListsTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    var listsDeleteAndSelection = true
    var data: [List] = []
    var parentController: ListsControllerPresenter?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell {
            if !listsDeleteAndSelection {
                cell.accessoryType = .none
            }
            
            let list = data[indexPath.row]
            cell.configure(with: list)

            return cell
        }
        fatalError("Unable to dequeue ListCell!")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentController?.listSelected(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if listsDeleteAndSelection {
            if editingStyle == .delete {
                parentController?.listDeleted(at: indexPath)
            }
        }
    }
    
}
