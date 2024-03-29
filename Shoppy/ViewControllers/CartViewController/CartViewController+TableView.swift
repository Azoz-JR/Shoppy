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
        tableView.backgroundColor = .secondBackground
        tableView.keyboardDismissMode = .onDrag
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(CartCellView.register(), forCellReuseIdentifier: CartCellView.identifier)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CartCellView.identifier, for: indexPath) as? CartCellView {
            let product = cartProducts[indexPath.row]
            cell.setUpCell(with: product)
            
            cell.increaseButtonHandler = { [weak self] in
                self?.progressView.startAnimating()
                
                self?.cartViewModel.addProduct(product: product) { error in
                    self?.progressView.stopAnimating()
                    
                    if let error {
                        self?.show(error: error)
                        return
                    }
                    
                    self?.updateUI()
                }
            }
            
            cell.decreaseButtonHandler = { [weak self] in
                self?.cartViewModel.decreaseProduct(product: product) { error in
                    self?.progressView.stopAnimating()
                    
                    if let error {
                        self?.show(error: error)
                        return
                    }
                    
                    self?.updateUI()
                }
                
            }
            
            cell.removeButtonHandler = { [weak self] in
                self?.cartViewModel.removeProduct(at: indexPath.row)
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
