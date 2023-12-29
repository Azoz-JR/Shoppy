//
//  OrderCollectionCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 29/12/2023.
//

import UIKit

class OrderCollectionCell: UICollectionViewCell {
    @IBOutlet var orderContainer: UIView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var itemsLabel: UILabel!
    
    
    static let identifier = "OrderCollectionCell"
    static func register() -> UINib {
        UINib(nibName: "OrderCollectionCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        orderContainer.layer.cornerRadius = 20
        orderContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        orderContainer.layer.borderWidth = 1
    }

    func configure(with order: Order) {
        priceLabel.text = "\(order.price)$"
        dateLabel.text = order.formattedDate
    }

}
