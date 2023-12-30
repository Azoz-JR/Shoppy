//
//  ItemCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 30/12/2023.
//

import UIKit

class ItemCell: UICollectionViewCell {
    @IBOutlet var itemContainer: UIView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    static let identifier = "ItemCell"
    static func register() -> UINib {
        UINib(nibName: "ItemCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator.startAnimating()
        
        itemContainer.layer.cornerRadius = 20
        itemContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        itemContainer.layer.borderWidth = 1
    }
    
    func configure(with item: ItemViewModel) {
        itemImage.sd_setImage(with: item.image) { [weak self] _, _, _, _ in
            self?.activityIndicator.stopAnimating()
        }
        itemCountLabel.text = "\(item.count)"
        itemLabel.text = item.title
        priceLabel.text = "\(item.price)$"
    }

}
