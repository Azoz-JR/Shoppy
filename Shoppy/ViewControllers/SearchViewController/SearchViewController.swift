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
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        configuareTableView()
        
        if let text {
            searchFor(text: text)
        }
    }
    
    func setUpNavBar() {
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search by "
        searchBar.tintColor = UIColor.lightGray
        searchBar.barTintColor = UIColor.lightGray
        searchBar.isTranslucent = true
        navigationItem.titleView = searchBar
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            searchTableViewDelegate.data = []
            reloadTableView()
            return
        }
        
        createSearchView(for: text)
    }
    
    func createSearchView(for text: String) {
        let searchVC = SearchViewController()
        searchVC.cartViewModel = cartViewModel
        searchVC.listsViewModel = listsViewModel
        searchVC.service = service
        searchVC.result = result
        searchVC.wishListViewModel = wishListViewModel
        searchVC.text = text
        
        show(searchVC, sender: self)
    }
    
    func searchFor(text: String) {
        searchTableViewDelegate.data = result.filter { product in
            product.title.localizedStandardContains(text)
            || (product.category?.rawValue ?? "").localizedStandardContains(text)
            || product.vendor.localizedStandardContains(text)
        }
        reloadTableView()
        
        guard !searchTableViewDelegate.data.isEmpty else {
            noResultsLabel.text = "No results for \(text)."
            noResultsView.isHidden = false
            return
        }
        
        noResultsView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.text = text
    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchTableViewDelegate.data = []
//        reloadTableView()
//    }
    
}
