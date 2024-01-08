//
//  ListDetailViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 30/12/2023.
//

import UIKit

class ListDetailViewController: UIViewController, ListDetailViewPresenter {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noItemsLabel: UILabel!
    
    let listItemsTableViewDelegate = ListItemsTableViewDelegate()
    var list: List
    var productsViewModel: ProductsViewModel
    var listsViewModel: ListsViewModel
    
    init(list: List, productsViewModel: ProductsViewModel, listsViewModel: ListsViewModel) {
        self.list = list
        self.productsViewModel = productsViewModel
        self.listsViewModel = listsViewModel
        
        super.init(nibName: "ListDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = list.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteList))
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
        
        configuareTableView()
    }
    
    func configuareTableView() {
        tableView.delegate = listItemsTableViewDelegate
        tableView.dataSource = listItemsTableViewDelegate
        
        listItemsTableViewDelegate.data = list.items
        listItemsTableViewDelegate.parentController = self
        listItemsTableViewDelegate.productsViewModel = productsViewModel
        listItemsTableViewDelegate.listsViewModel = listsViewModel
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(ListItemCellView.register(), forCellReuseIdentifier: ListItemCellView.identifier)
    }
    
    func showAlert() {
        showAddedSuccessfulyAlert()
    }
    
    func itemSelected(at index: IndexPath) {
        let product = list.items[index.row]
        select(product: product, productsViewModel: productsViewModel, listsViewModel: listsViewModel)
    }
    
    func itemDeleted(at index: IndexPath) {
        showDeleteListAlert(index: index)
    }
    
    func showDeleteListAlert(index: IndexPath) {
        let alert = UIAlertController(title: "Delete item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(index: index)
        }))
        
        present(alert, animated: true)
    }
    
    func deleteItem(index: IndexPath) {
        listItemsTableViewDelegate.data.remove(at: index.row)
        tableView.deleteRows(at: [index], with: .fade)
        
        let item = list.items[index.row]
        listsViewModel.remove(item: item, at: index.row)
    }
    
    @objc func deleteList() {
        let alert = UIAlertController(title: "Delete list", message: "Are you sure you want to delete this list?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let list = self?.list else {
                return
            }
            
            self?.listsViewModel.delete(list: list)
            self?.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !list.items.isEmpty {
            noItemsLabel.isHidden = true
        } else {
            noItemsLabel.isHidden = false
        }
    }
    

}
