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
        
        orderContainer.round(10)
        orderContainer.addBorder(color: .lightGray.withAlphaComponent(0.5), width: 1)
    }

    func configure(with order: Order) {
        let titles = order.items.map( { $0.title })
        itemsLabel.text = titles.joined(separator: ", ")
        priceLabel.text = "\(order.price)$"
        dateLabel.text = order.formattedDate
    }

}
