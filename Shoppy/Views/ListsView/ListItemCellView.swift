//
//  ListItemCellView.swift
//  Shoppy
//
//  Created by Azoz Salah on 04/01/2024.
//

import UIKit

class ListItemCellView: UITableViewCell {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var optionsButton: UIButton!
    @IBOutlet var addToCartButton: UIButton!
    @IBOutlet var productPriceLabel: UILabel!
    @IBOutlet var productCollectionLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    
    static let identifier = "ListItemCell"
    static func register() -> UINib {
        UINib(nibName: "ListItemCellView", bundle: nil)
    }
    
    var addToCartHandler: (() -> Void)?
    var optionsHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.round()
        containerView.addBorder(color: .lightGray.withAlphaComponent(0.2), width: 1)
        productImageView.addBorder(color: .lightGray.withAlphaComponent(0.2), width: 1)
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        optionsButton.addTarget(self, action: #selector(optionsTapped), for: .touchUpInside)
        
        activityIndicator.startAnimating()
    }
    
    func configure(with product: ItemViewModel) {
        let url = product.image
        productImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
            self?.activityIndicator.stopAnimating()
        }
        productNameLabel.text = product.title
        productPriceLabel.text = "$\(product.price)"
        productCollectionLabel.text = "By \(product.vendor)"
    }

    @objc func addToCartTapped() {
        addToCartHandler?()
    }
    
    @objc func optionsTapped() {
        optionsHandler?()
    }
    
}
