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
    var cartViewModel: CartViewModel
    var listsViewModel: ListsViewModel
    var wishListViewModel: WishListViewModel
    
    init(list: List, cartViewModel: CartViewModel, listsViewModel: ListsViewModel, wishListViewModel: WishListViewModel) {
        self.list = list
        self.cartViewModel = cartViewModel
        self.listsViewModel = listsViewModel
        self.wishListViewModel = wishListViewModel
        
        super.init(nibName: "ListDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configNavigationBar()
        configuareTableView()
    }
    
    func configNavigationBar() {
        title = list.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteList))
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    func showAlert(error: Error?) {
        if let error {
            show(error: error)
            return
        }
        
        showAddedSuccessfulyAlert()
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
