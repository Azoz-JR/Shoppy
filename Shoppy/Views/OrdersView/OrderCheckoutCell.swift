//
//  OrderCheckoutCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 03/02/2024.
//

import UIKit

class OrderCheckoutCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var valueLabel: UILabel!
    
    static let identifier = "CheckoutCell"
    static func register() -> UINib {
        UINib(nibName: "OrderCheckoutCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
}
