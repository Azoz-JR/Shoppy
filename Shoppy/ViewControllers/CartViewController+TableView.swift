//
//  CartViewController+TableView.swift
//  Shoppy
//
//  Created by Azoz Salah on 13/12/2023.
//

import UIKit

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(CartCellView.register(), forCellReuseIdentifier: CartCellView.identifier)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        uniqueProducts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CartCellView.identifier, for: indexPath) as? CartCellView {
            let product = uniqueProducts[indexPath.row]
            cell.setUpCell(with: product)
            
            cell.increaseButtonHandler = { [weak self] in
                self?.increaseProduct(at: indexPath)
                self?.updateUI()
            }
            
            cell.decreaseButtonHandler = { [weak self] in
                self?.decreseProduct(at: indexPath)
                self?.updateUI()
            }
            
            cell.removeButtonHandler = { [weak self] in
                self?.removeProduct(at: indexPath)
                self?.updateUI()
            }
            
            return cell
        }
        fatalError("Unable to dequeue CartCellView")
    }
    
    func increaseProduct(at index: IndexPath) {
        uniqueProducts[index.row].increaseCount()
        tableView.reloadRows(at: [index], with: .automatic)
    }
    
    func decreseProduct(at index: IndexPath) {
        guard uniqueProducts[index.row].count > 1 else {
            removeProduct(at: index)
            return
        }
        
        uniqueProducts[index.row].decreaseCount()
        tableView.reloadRows(at: [index], with: .automatic)
    }
    
    func removeProduct(at index: IndexPath) {
        uniqueProducts.remove(at: index.row)
        tableView.reloadData()
    }
    
}
