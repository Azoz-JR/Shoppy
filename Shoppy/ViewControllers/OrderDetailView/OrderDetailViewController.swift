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
        
        title = "Order Items"

        configureorderDetails()
        configuareTableView()
    }


    func configureorderDetails() {
        detailsContainer.layer.cornerRadius = 20
        detailsContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        detailsContainer.layer.borderWidth = 1
        
        orderPriceLabel.text = "\(order.price)$"
        orderDateLabel.text = order.formattedDate
    }
    
    func configuareTableView() {
        tableView.delegate = orderTableViewDelegate
        tableView.dataSource = orderTableViewDelegate
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        
        orderTableViewDelegate.data = order.items
        
        registerCell()
    }
    
    func registerCell() {
        tableView.register(OrderItemCell.register(), forCellReuseIdentifier: OrderItemCell.identifier)
    }

}
