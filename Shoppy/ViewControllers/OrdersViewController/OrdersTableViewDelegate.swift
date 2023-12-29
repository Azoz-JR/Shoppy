//
//  OrdersTableViewDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 29/12/2023.
//

import UIKit

class OrdersTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var data: [Order] = []
    var parentController: OrdersControllerPresenter?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderCellView {
            let order = data[indexPath.row]
            cell.configure(with: order)
            
            return cell
        }
        fatalError("Unable to dequeue OrderCellView!")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentController?.orderSelected(at: indexPath.row)
    }
    
    
}
