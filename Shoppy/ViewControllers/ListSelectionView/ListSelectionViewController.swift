//
//  ListSelectionViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 31/12/2023.
//

import UIKit
import RxSwift

class ListSelectionViewController: UIViewController, ListsControllerPresenter {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noListsLabel: UILabel!
    
    var item: ItemModel
    var listsViewModel: ListsViewModel
    
    let listsTableViewDelegate = ListsSelectionTableViewDelegate()
    var lists: [List] = []
    private let disposeBag = DisposeBag()
    
    init(item: ItemModel, listsViewModel: ListsViewModel) {
        self.listsViewModel = listsViewModel
        self.item = item
        
        super.init(nibName: "ListSelectionView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
        configNavigationBar()
        bindToListsViewModel()
        configuareTableView()
    }
    
    func refresh() {
        Task {
            do {
                try await listsViewModel.getLists()
            } catch {
                show(error: error)
            }
        }
    }
    
    func configNavigationBar() {
        title = "Your Lists"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addListTapped))
        navigationItem.rightBarButtonItem?.tintColor = .selectedTab
        
        view.backgroundColor = .clear
    }
    
    func bindToListsViewModel() {
        listsViewModel.lists.subscribe { [weak self] lists in
            self?.lists = lists
            self?.listsTableViewDelegate.data = lists
            self?.reloadTableView()
            
            guard lists.isEmpty else {
                self?.noListsLabel.isHidden = true
                return
            }
            self?.noListsLabel.isHidden = false
        }
        .disposed(by: disposeBag)
        
    }
    
    @objc func addListTapped() {
        showCreateListView(listsViewModel: listsViewModel)
    }
    
}
