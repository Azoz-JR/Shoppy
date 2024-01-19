//
//  OrdersViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 29/12/2023.
//

import UIKit

class OrdersViewController: UIViewController, OrdersControllerPresenter {
    @IBOutlet var tableView: UITableView!
    
    let ordersTableViewDelegate = OrdersTableViewDelegate()
    var orders: [Order]
    
    init(orders: [Order]) {
        self.orders = orders
        
        super.init(nibName: "OrdersViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Previous Orders"

        configuareTableView()
    }
    
    func configuareTableView() {
        tableView.delegate = ordersTableViewDelegate
        tableView.dataSource = ordersTableViewDelegate
        
        ordersTableViewDelegate.data = orders
        ordersTableViewDelegate.parentController = self
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(OrderCellView.register(), forCellReuseIdentifier: OrderCellView.identifier)
    }
    
    func orderSelected(at index: Int) {
        let order = orders[index]
        let vc = OrderDetailViewController(order: order)
        vc.title = "Order Items"
        
        show(vc, sender: self)
    }

}
