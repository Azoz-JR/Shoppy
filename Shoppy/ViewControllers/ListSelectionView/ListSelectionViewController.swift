//
//  ListSelectionViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 31/12/2023.
//

import UIKit

class ListSelectionViewController: UIViewController, ListsControllerPresenter, UIScrollViewDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noListsLabel: UILabel!
    
    let listsTableViewDelegate = ListsSelectionTableViewDelegate()
    var lists: [List] = []
    
    var item: ItemViewModel
    var listsViewModel: ListsViewModel
    
    init(item: ItemViewModel, listsViewModel: ListsViewModel) {
        self.listsViewModel = listsViewModel
        self.item = item
        
        super.init(nibName: "ListSelectionView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Your Lists"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addListTapped))
        navigationItem.rightBarButtonItem?.tintColor = .selectedTab
        
        view.backgroundColor = .clear
        
        bindToListsViewModel()
        configuareTableView()
    }
    
    func configuareTableView() {
        listsTableViewDelegate.parentController = self
        tableView.delegate = listsTableViewDelegate
        tableView.dataSource = listsTableViewDelegate
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(ListCell.register(), forCellReuseIdentifier: ListCell.identifier)
    }
    
    func bindToListsViewModel() {
        listsViewModel.lists.addObserver { [weak self] lists in
            guard let lists else {
                return
            }
            
            if lists.isEmpty {
                self?.noListsLabel.isHidden = false
            } else {
                self?.noListsLabel.isHidden = true
            }
            
            self?.lists = lists
            self?.listsTableViewDelegate.data = lists
            self?.reloadTableView()
        }
    }
    
    func listSelected(at index: Int) {
        guard !lists[index].contains(item: item) else {
            showAlert(title: "This item is already added to this list before.", dismiss: false)
            return
        }
        
        listsViewModel.add(item: item, at: index)
        showAlert(title: "Item added succesfully to \(lists[index].name)", dismiss: true)
    }
    
    func reloadTableView() {
        DispatchQueue.mainAsyncIfNeeded {
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve) {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func addListTapped() {
        showCreateListView(listsViewModel: listsViewModel)
    }
    
}
