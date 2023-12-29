//
//  OrderCellView.swift
//  Shoppy
//
//  Created by Azoz Salah on 29/12/2023.
//

import UIKit

class OrderCellView: UITableViewCell {
    @IBOutlet var orderContainer: UIView!
    @IBOutlet var orderPriceLabel: UILabel!
    @IBOutlet var orderDateLabel: UILabel!
    
    static let identifier = "OrderCell"
    static func register() -> UINib {
        UINib(nibName: "OrderCellView", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        orderContainer.layer.cornerRadius = 20
        orderContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        orderContainer.layer.borderWidth = 1
    }

    func configure(with order: Order) {
        orderPriceLabel.text = "\(order.price)$"
        orderDateLabel.text = order.formattedDate
    }
    
}
