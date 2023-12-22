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
        tableView.allowsSelection = false
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(CartCellView.register(), forCellReuseIdentifier: CartCellView.identifier)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CartCellView.identifier, for: indexPath) as? CartCellView {
            let product = cartProducts[indexPath.row]
            cell.setUpCell(with: product)
            
            cell.increaseButtonHandler = { [weak self] in
                self?.viewModel.addProduct(product: product)
                self?.updateUI()
            }
            
            cell.decreaseButtonHandler = { [weak self] in
                self?.viewModel.removeProduct(product: product)
                self?.updateUI()
            }
            
            cell.removeButtonHandler = { [weak self] in
                self?.viewModel.removeProduct(at: indexPath.row)
                self?.updateUI()
            }
            
            return cell
        }
        fatalError("Unable to dequeue CartCellView")
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve) {
                self.tableView.reloadData()
            }
        }
    }
    
}
