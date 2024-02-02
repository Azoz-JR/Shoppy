//
//  OrderDetailViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 29/12/2023.
//

import UIKit

class OrderDetailViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var detailsContainer: UIView!
    @IBOutlet var orderPriceLabel: UILabel!
    @IBOutlet var orderDateLabel: UILabel!
    
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
        detailsContainer.layer.cornerRadius = 20
        detailsContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        detailsContainer.layer.borderWidth = 1
        
        orderPriceLabel.text = "\(order.total)$"
        orderDateLabel.text = order.formattedDate
    }
    
    func configuareTableView() {
        tableView.delegate = orderTableViewDelegate
        tableView.dataSource = orderTableViewDelegate
        
        orderTableViewDelegate.data = order.items
        orderTableViewDelegate.parentController = self
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(OrderItemCell.register(), forCellReuseIdentifier: OrderItemCell.identifier)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backButtonDisplayMode = .minimal
    }

}
