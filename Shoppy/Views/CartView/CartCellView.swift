//
//  CartCellView.swift
//  Shoppy
//
//  Created by Azoz Salah on 12/12/2023.
//

import SDWebImage
import UIKit

final class CartCellView: UITableViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var reduceLabel: UIButton!
    @IBOutlet var increaseLabel: UIButton!
    @IBOutlet var productCount: UILabel!
    
    var increaseButtonHandler: (() -> Void)?
    var decreaseButtonHandler: (() -> Void)?
    var removeButtonHandler: (() -> Void)?

    static let identifier = "CartCellView"
    static func register() -> UINib {
        UINib(nibName: "CartCellView", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        containerView.backgroundColor = .sectionBackground
        containerView.applyShadow(cornerRadius: 20)
        productImage.round(20)
        productImage.addBorder(color: .lightGray.withAlphaComponent(0.3), width: 1)
        
        increaseLabel.addTarget(self, action: #selector(increaseButtonTapped), for: .touchUpInside)
        reduceLabel.addTarget(self, action: #selector(decreaseButtonTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
    
    func setUpCell(with product: ItemViewModel) {
        productImage.sd_setImage(with: product.image)
        productLabel.text = product.title
        categoryLabel.text = product.category?.rawValue
        priceLabel.text = "\(product.price)$"
        productCount.text = "\(product.count)"
    }
    
    @objc func increaseButtonTapped() {
        increaseButtonHandler?()
    }
    
    @objc func decreaseButtonTapped() {
        decreaseButtonHandler?()
    }
    
    @objc func removeButtonTapped() {
        removeButtonHandler?()
    }
        
}
