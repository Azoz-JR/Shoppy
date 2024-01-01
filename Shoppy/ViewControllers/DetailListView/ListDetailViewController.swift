//
//  ListDetailViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 30/12/2023.
//

import UIKit

class ListDetailViewController: UIViewController, ParentControllerPresenter {
    
    @IBOutlet var itemsCollection: UICollectionView!
    
    let productsCollectioDelegateAndDataSource = ProductsCollectionDataSourceAndDelegate()
    
    var list: List
    var productsViewModel: ProductsViewModel
    var listsViewModel: ListsViewModel
    
    init(list: List, productsViewModel: ProductsViewModel, listsViewModel: ListsViewModel) {
        self.list = list
        self.productsViewModel = productsViewModel
        self.listsViewModel = listsViewModel
        
        super.init(nibName: "ListDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = list.name
        
        configuareCollectionView()
    }
    
    func configuareCollectionView() {
        itemsCollection.delegate = productsCollectioDelegateAndDataSource
        itemsCollection.dataSource = productsCollectioDelegateAndDataSource
        
        productsCollectioDelegateAndDataSource.data = list.items
        productsCollectioDelegateAndDataSource.parentController = self
        productsCollectioDelegateAndDataSource.productsViewModel = productsViewModel
        productsCollectioDelegateAndDataSource.listsViewModel = listsViewModel
        
        registerCell()
    }
    
    func registerCell() {
        itemsCollection.register(ProductCell.register(), forCellWithReuseIdentifier: ProductCell.identifier)
    }
    
    func showAlert() {
        showAddedSuccessfulyAlert()
    }
    
    func itemSelected(at index: IndexPath) {
        let product = list.items[index.row]
        select(product: product, productsViewModel: productsViewModel, listsViewModel: listsViewModel)
    }

}
