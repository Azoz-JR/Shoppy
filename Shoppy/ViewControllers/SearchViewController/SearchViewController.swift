//
//  SearchViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 08/01/2024.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noResultsView: UIView!
    @IBOutlet var noResultsLabel: UILabel!
    
    let searchBar = UISearchBar()
    let searchTableViewDelegate = SearchTableViewDelegate()
    
    var cartViewModel: CartViewModel?
    var listsViewModel: ListsViewModel?
    var wishListViewModel: WishListViewModel?
    var service: Service?
    var result: [ItemModel] = []
    
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
        
        guard !searchTableViewDelegate.data.isEmpty else {
            noResultsLabel.text = "No results for \(text)."
            noResultsView.isHidden = false
            return
        }
        
        noResultsView.isHidden = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchTableViewDelegate.data = []
        reloadTableView()
    }
    
}
