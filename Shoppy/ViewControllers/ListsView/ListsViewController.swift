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
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addListTapped))
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
        navigationItem.rightBarButtonItems = [addBarButton, editBarButton]

        configuareTableView()
    }
    
    @objc func addListTapped() {
        showCreateListView(listsViewModel: listsViewModel)
    }
    
    @objc func editTapped() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            navigationItem.rightBarButtonItems?[1] = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTapped))
        } else {
            navigationItem.rightBarButtonItems?[1] = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        }
    }
    
    func bindtoListsViewModel() {
        listsViewModel.lists.addObserver { [weak self] lists in
            guard let self, let lists else {
                return
            }
            
            if lists.isEmpty {
                noListsLabel.isHidden = false
            } else {
                noListsLabel.isHidden = true
            }
            
            self.lists = lists
            self.listsTableViewDelegate.data = lists
            reloadTableView()
        }
    }
    
    func showDeleteListAlert(title: String, index: IndexPath) {
        let alert = UIAlertController(title: "", message: "Delete \(title) list?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteList(index: index)
        }))
        
        present(alert, animated: true)
    }
    
    private func deleteList(index: IndexPath) {
        listsTableViewDelegate.data.remove(at: index.row)
        tableView.deleteRows(at: [index], with: .fade)
        
        let list = lists[index.row]
        listsViewModel.delete(list: list)
    }

}


//MARK: TableView Configurations
extension ListsViewController {
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
    
    func reloadTableView() {
        DispatchQueue.mainAsyncIfNeeded {
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve) {
                self.tableView.reloadData()
            }
        }
    }
    
    func listSelected(at index: Int) {
        let list = lists[index]
        let vc = ListDetailViewController(list: list, productsViewModel: productsViewModel, listsViewModel: listsViewModel)
        
        show(vc, sender: self)
    }
    
    func listDeleted(at index: IndexPath) {
        let listTitle = lists[index.row].name
        showDeleteListAlert(title: listTitle, index: index)
    }
}
