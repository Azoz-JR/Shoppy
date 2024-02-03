//
//  OrderTableViewDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 05/01/2024.
//

import UIKit

class OrderTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    var parentController: ScrollViewDelegate?

    
    var checkoutDetails: [String] = []
    let checkoutTitles = ["Created at:", "Subtotal:", "Discount:", "Total:"]
    
    var data: [ItemModel] = []
    
    
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: OrderCheckoutCell.identifier, for: indexPath) as? OrderCheckoutCell {
                let title = checkoutTitles[indexPath.row]
                let value = checkoutDetails[indexPath.row]
                
                cell.configure(title: title, value: value)
                return cell
            }
            fatalError("Unable to dequeue OrderCheckoutCell")
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: OrderItemCell.identifier, for: indexPath) as? OrderItemCell {
            let item = data[indexPath.row]
            cell.configure(with: item)
            cell.backgroundColor = .clear
            
            return cell
        }
        fatalError("Unable to deque ListItemCellView")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        parentController?.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        parentController?.scrollViewDidScroll(scrollView)
    }
    
}
