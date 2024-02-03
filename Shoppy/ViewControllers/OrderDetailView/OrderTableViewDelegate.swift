//
//  OrderTableViewDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 05/01/2024.
//

import UIKit

class OrderTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var checkoutDetails: [String] = []
    var data: [ItemModel] = []
    
    var parentController: ScrollViewDelegate?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return checkoutDetails.count
        } else {
            return data.count
        }
        
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Checkout details"
        } else {
            return "Items"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = checkoutDetails[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: OrderItemCell.identifier, for: indexPath) as? OrderItemCell {
            let item = data[indexPath.row]
            cell.configure(with: item)
            cell.backgroundColor = .clear
            
            return cell
        }
        fatalError("Unable to deque ListItemCellView")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        parentController?.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        parentController?.scrollViewDidScroll(scrollView)
    }
    
}
