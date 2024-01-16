//
//  OrderTableViewDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 05/01/2024.
//

import UIKit

class OrderTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var data: [ItemModel] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: OrderItemCell.identifier, for: indexPath) as? OrderItemCell {
            let item = data[indexPath.row]
            cell.configure(with: item)
            
            return cell
        }
        fatalError("Unable to deque ListItemCellView")
    }
    
}
