//
//  ListsViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 30/12/2023.
//

import UIKit

class ListsViewController: UIViewController, ListsControllerPresenter {
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var noListsLabel: UILabel!
    let listsTableViewDelegate = ListsTableViewDelegate()
    var lists: [List] = []
    
    var productsViewModel: ProductsViewModel
    var listsViewModel: ListsViewModel
    
    init(productsViewModel: ProductsViewModel, listsViewModel: ListsViewModel) {
        self.productsViewModel = productsViewModel
        self.listsViewModel = listsViewModel
        
        super.init(nibName: "ListsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindtoListsViewModel()
        
        title = "Your Lists"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addListTapped))

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
        let vc = ListDetailViewController(list: list, productsViewModel: productsViewModel, listsViewModel: listsViewModel)
        
        show(vc, sender: self)
    }
    
    @objc func addListTapped() {
        showCreateListView(listsViewModel: listsViewModel)
    }
    
    func bindtoListsViewModel() {
        listsViewModel.lists.addObserver { [weak self] lists in
            guard let self, let lists else {
                return
            }
            
            if lists.isEmpty {
                noListsLabel.isHidden = false
            }
            
            noListsLabel.isHidden = true
            self.lists = lists
            self.listsTableViewDelegate.data = lists
            reloadTableView()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.mainAsyncIfNeeded {
            self.tableView.reloadData()
        }
    }

}
