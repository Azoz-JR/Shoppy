//
//  ListSelectionViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 31/12/2023.
//

import UIKit

class ListSelectionViewController: UIViewController, ListsControllerPresenter {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noListsLabel: UILabel!
    
    var item: ItemViewModel
    var listsViewModel: ListsViewModel
    
    let listsTableViewDelegate = ListsSelectionTableViewDelegate()
    var lists: [List] = []
    
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
        
        configNavigationBar()
        bindToListsViewModel()
        configuareTableView()
    }
    
    func configNavigationBar() {
        title = "Your Lists"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addListTapped))
        navigationItem.rightBarButtonItem?.tintColor = .selectedTab
        
        view.backgroundColor = .clear
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
    
    @objc func addListTapped() {
        showCreateListView(listsViewModel: listsViewModel)
    }
    
}
