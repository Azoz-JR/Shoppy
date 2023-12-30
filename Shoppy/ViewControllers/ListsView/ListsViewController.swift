//
//  ListsViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 30/12/2023.
//

import UIKit

class ListsViewController: UIViewController, ListsControllerPresenter {
    @IBOutlet var tableView: UITableView!
    
    let listsTableViewDelegate = ListsTableViewDelegate()
    var lists: [List]
    var productsViewModel: ProductsViewModel
    
    init(lists: [List], productsViewModel: ProductsViewModel) {
        self.lists = lists
        self.productsViewModel = productsViewModel
        
        super.init(nibName: "ListsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Your Lists"

        configuareTableView()
    }
    
    func configuareTableView() {
        tableView.delegate = listsTableViewDelegate
        tableView.dataSource = listsTableViewDelegate
        
        listsTableViewDelegate.data = lists
        listsTableViewDelegate.parentController = self
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(ListCell.register(), forCellReuseIdentifier: ListCell.identifier)
    }
    
    func listSelected(at index: Int) {
        let list = lists[index]
        let vc = ListDetailViewController(list: list, productsViewModel: productsViewModel)
        
        show(vc, sender: self)
    }

}
