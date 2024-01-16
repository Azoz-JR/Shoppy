//
//  SearchTableViewCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 08/01/2024.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var vendorLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    static let identifier = "SearchItemCell"
    static func register() -> UINib {
        UINib(nibName: "SearchTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.round()
        containerView.addBorder(color: .lightGray.withAlphaComponent(0.3), width: 1)
        
        configureImageView()
        
        activityIndicator.startAnimating()
    }
    
    func configure(with product: ItemModel) {
        let url = product.image
        itemImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
            self?.activityIndicator.stopAnimating()
        }
        titleLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        vendorLabel.text = "By \(product.vendor)"
    }
    
    func configureImageView() {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        borderLayer.frame = CGRect(x: itemImageView.bounds.maxX - 1, y: itemImageView.bounds.minY, width: 1, height: itemImageView.bounds.height)
        itemImageView.layer.addSublayer(borderLayer)
    }
    
}
