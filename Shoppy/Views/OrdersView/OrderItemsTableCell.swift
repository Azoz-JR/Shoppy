//
//  OrderItemsTableCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 18/01/2024.
//

import UIKit

class OrderItemsTableCell: UITableViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var vendorLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    
    
    static let identifier = "OrderItemsTableCell"
    static func register() -> UINib {
        UINib(nibName: "OrderItemsTableCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.round()
        containerView.addBorder(color: .lightGray.withAlphaComponent(0.2), width: 1)
        configureImageView()
        
        activityIndicator.startAnimating()
        
    }

    func configure(with item: ItemModel) {
        itemImageView.sd_setImage(with: item.image) { [weak self] _, _, _, _ in
            self?.activityIndicator.stopAnimating()
        }
        
        colorLabel.text = item.color
        sizeLabel.text = item.size
        vendorLabel.text = "By \(item.vendor)"
        quantityLabel.text = "\(item.count)"
        nameLabel.text = item.title
        priceLabel.text = "\(item.price)$"
        
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        borderLayer.frame = CGRect(x: itemImageView.frame.width - 1, y: 0, width: 1, height: itemImageView.frame.height)
        containerView.layer.addSublayer(borderLayer)
        
    }
    
    func configureImageView() {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        borderLayer.frame = CGRect(x: itemImageView.bounds.maxX - 1, y: itemImageView.bounds.minY, width: 1, height: itemImageView.bounds.height)
        itemImageView.layer.addSublayer(borderLayer)
    }
    
}
