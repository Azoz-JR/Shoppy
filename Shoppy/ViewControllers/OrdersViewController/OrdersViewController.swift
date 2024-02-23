//
//  OrdersViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 29/12/2023.
//

import RxSwift
import UIKit

class OrdersViewController: UIViewController, OrdersControllerPresenter {
    @IBOutlet var tableView: UITableView!
    
    let ordersTableViewDelegate = OrdersTableViewDelegate()
    var cartViewModel: CartViewModel?
    let disposeBag = DisposeBag()
    private var refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Your Orders"
        navigationItem.backButtonDisplayMode = .minimal
        
        //Refresh View
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .myGreen
        tableView.refreshControl = refreshControl

        bindToOrders()
        configuareTableView()
        
        refresh()
    }
    
    @objc func refresh() {
        Task {
            do {
                try await cartViewModel?.getOrders()
                
                endRefreshing()
            } catch {
                endRefreshing()
                show(error: error)
            }
        }
    }
    
    func bindToOrders() {
        cartViewModel?.orders.subscribe(onNext: { [weak self] orders in
            guard let self else {
                self?.updateOrders()
                return
            }
            
            self.ordersTableViewDelegate.data = orders
            self.updateOrders()
        })
        .disposed(by: disposeBag)
        
    }
    
    func updateOrders() {
        DispatchQueue.mainAsyncIfNeeded {
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve) {
                self.tableView.reloadData()
            }
        }
    }
    
    func configuareTableView() {
        tableView.delegate = ordersTableViewDelegate
        tableView.dataSource = ordersTableViewDelegate
        
        ordersTableViewDelegate.parentController = self
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(OrderCellView.register(), forCellReuseIdentifier: OrderCellView.identifier)
    }
    
    func orderSelected(at index: Int) {
        let order = ordersTableViewDelegate.data[index]
        let vc = OrderDetailViewController(order: order)
        vc.title = "Order Items"
        
        show(vc, sender: self)
    }
    
    func endRefreshing() {
        DispatchQueue.mainAsyncIfNeeded {
            self.refreshControl.endRefreshing()
        }
    }

}
