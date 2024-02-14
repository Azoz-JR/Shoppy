//
//  ListsViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 30/12/2023.
//

import UIKit
import RxSwift

class ListsViewController: UIViewController, ListsControllerPresenter {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noListsLabel: UILabel!
    
    var cartViewModel: CartViewModel
    var listsViewModel: ListsViewModel
    var wishListViewModel: WishListViewModel
    private let disposeBag = DisposeBag()
    let listsTableViewDelegate = ListsTableViewDelegate()
    private var refreshControl = UIRefreshControl()
    
    init(cartViewModel: CartViewModel, listsViewModel: ListsViewModel, wishListViewModel: WishListViewModel) {
        self.cartViewModel = cartViewModel
        self.listsViewModel = listsViewModel
        self.wishListViewModel = wishListViewModel
        
        super.init(nibName: "ListsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Your Lists"
        
        //Refresh View
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .myGreen
        tableView.refreshControl = refreshControl
        
        refresh()
        bindtoListsViewModel()
        configNavigationBar()
        configuareTableView()
    }
    
    @objc func refresh() {
        Task {
            do {
                try await listsViewModel.getLists()
                
                endRefreshing()
            } catch {
                    endRefreshing()
                    show(error: error)
            }
        }
        
    }
    
    func bindtoListsViewModel() {
        listsViewModel.lists.subscribe { [weak self] lists in
            guard let self else {
                return
            }
            
            self.listsTableViewDelegate.data = lists
            reloadTableView()
            
            if lists.isEmpty {
                noListsLabel.isHidden = false
            } else {
                noListsLabel.isHidden = true
            }
        }
        .disposed(by: disposeBag)
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
    
    func configNavigationBar() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addListTapped))
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
        navigationItem.rightBarButtonItems = [addBarButton, editBarButton]
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
        let list = listsTableViewDelegate.data[index.row]
        
        listsTableViewDelegate.data.remove(at: index.row)
        tableView.deleteRows(at: [index], with: .fade)
        listsViewModel.delete(list: list)
    }
    
    func endRefreshing() {
        DispatchQueue.mainAsyncIfNeeded {
            self.refreshControl.endRefreshing()
        }
    }

}
