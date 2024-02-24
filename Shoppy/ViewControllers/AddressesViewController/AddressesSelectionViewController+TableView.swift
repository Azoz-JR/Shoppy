//
//  AddressesSelectionViewController+TableView.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/02/2024.
//

import UIKit

extension AddressesSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddressTableViewCell.register(), forCellReuseIdentifier: AddressTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as? AddressTableViewCell {
            let address = addresses[indexPath.row]
            let isSelected = address == selectedAddress
            
            cell.configure(with: address, isSelected: isSelected)
            
            cell.selectAddressHandler = { [weak self] in
                self?.selectAddress(address: address)
            }
            
            cell.editAddressHandler = { [weak self] in
                self?.editAddress(address: address)
            }
            
            return cell
        }
        
        fatalError("Unable to dequeue AddressTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                
        let delete = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            
            self?.deleteAddress(at: indexPath)
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
    
    func reloadTableView() {
        DispatchQueue.mainAsyncIfNeeded {
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve) {
                self.tableView.reloadData()
            }
        }
    }
    
    func deleteAddress(at index: IndexPath) {
        showProgressView()
        
        Task {
            do {
                let address = addresses[index.row]
                try await userViewModel.deleteAddress(address: address)
                
                hideProgressView()
            } catch {
                hideProgressView()
                show(error: error)
            }
        }
    }
}
