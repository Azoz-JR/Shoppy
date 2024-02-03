//
//  OrderDetailViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 29/12/2023.
//

import UIKit

class OrderDetailViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    let orderTableViewDelegate = OrderTableViewDelegate()
    
    var navBarVisible = true
    var lastContentOffset: CGFloat = 0
    
    var order: Order
    
    init(order: Order) {
        self.order = order
        
        super.init(nibName: "OrderDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureOrderDetails()
        configuareTableView()
    }


    func configureOrderDetails() {
        orderTableViewDelegate.checkoutDetails = [
            order.formattedDate,
            "\(order.subTotal)$",
            "-\(order.discount)$",
            "\(order.total)$"
        ]
    }
    
    func configuareTableView() {
        tableView.delegate = orderTableViewDelegate
        tableView.dataSource = orderTableViewDelegate
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 230
        
        orderTableViewDelegate.data = order.items
        orderTableViewDelegate.parentController = self
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(OrderItemCell.register(), forCellReuseIdentifier: OrderItemCell.identifier)
        tableView.register(OrderCheckoutCell.register(), forCellReuseIdentifier: OrderCheckoutCell.identifier)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.tabBarController?.tabBar.isHidden = true

    }

}
