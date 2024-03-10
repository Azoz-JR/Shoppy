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
    @IBOutlet var addToCartButton: UIButton!
    @IBOutlet var productColorLabel: UILabel!
    @IBOutlet var productSizeLabel: UILabel!
    @IBOutlet var productPriceLabel: UILabel!
    @IBOutlet var productCollectionLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var imageContainerView: UIView!
    @IBOutlet var productImageView: UIImageView!
    
    static let identifier = "ListItemCell"
    static func register() -> UINib {
        UINib(nibName: "ListItemCellView", bundle: nil)
    }
    
    var addToCartHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.round()
        containerView.addBorder(color: .lightGray.withAlphaComponent(0.2), width: 1)
        
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        
        activityIndicator.startAnimating()
    }
    
    func configure(with product: ItemModel) {
        productNameLabel.text = product.title
        productPriceLabel.text = "$\(product.price)"
        productCollectionLabel.text = "By \(product.vendor)"
        productColorLabel.text = product.color
        productSizeLabel.text = product.size
        configureImageView()
        
        let url = product.image
        productImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    func configureImageView() {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        borderLayer.frame = CGRect(x: imageContainerView.bounds.maxX - 1, y: imageContainerView.bounds.minY, width: 1, height: imageContainerView.bounds.height)
        
        containerView.layer.addSublayer(borderLayer)
    }

    @objc func addToCartTapped() {
        addToCartHandler?()
    }
    
}
