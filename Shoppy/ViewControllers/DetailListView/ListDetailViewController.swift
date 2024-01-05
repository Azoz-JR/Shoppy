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
        
        configuareCollectionView()
    }
    
    func configuareCollectionView() {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !list.items.isEmpty {
            noItemsLabel.isHidden = true
        } else {
            noItemsLabel.isHidden = false
        }
    }
    

}
