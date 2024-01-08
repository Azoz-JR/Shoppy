//
//  SearchViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 08/01/2024.
//

import UIKit

class SearchViewController: UIViewController, SearchViewPresenter, UISearchBarDelegate {
    @IBOutlet var tableView: UITableView!
    
    let searchBar = UISearchBar()
    let searchTableViewDelegate = SearchTableViewDelegate()
    
    var productsViewModel: ProductsViewModel?
    var listsViewModel: ListsViewModel?
    var service: Service?
    var result: [ItemViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        configuareTableView()
    }
    
    func setUpNavBar() {
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search by "
        searchBar.tintColor = UIColor.lightGray
        searchBar.barTintColor = UIColor.lightGray
        navigationItem.titleView = searchBar
        searchBar.isTranslucent = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            searchTableViewDelegate.data = []
            reloadTableView()
            return
        }
        
        searchTableViewDelegate.data = result.filter { product in
            product.title.uppercased().contains(text.uppercased())
        }
        reloadTableView()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchTableViewDelegate.data = []
        reloadTableView()
    }
    
    func configuareTableView() {
        tableView.delegate = searchTableViewDelegate
        tableView.dataSource = searchTableViewDelegate
        tableView.keyboardDismissMode = .onDrag
        
        searchTableViewDelegate.parentController = self
        searchTableViewDelegate.productsViewModel = productsViewModel
        searchTableViewDelegate.listsViewModel = listsViewModel
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(SearchTableViewCell.register(), forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve) {
                self.tableView.reloadData()
            }
        }
    }
    
    func itemSelected(at index: IndexPath) {
        guard let productsViewModel, let listsViewModel else {
            return
        }
        
        let product = searchTableViewDelegate.data[index.row]
        
        select(product: product, productsViewModel: productsViewModel, listsViewModel: listsViewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
}
