//
//  CollectionCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/12/2023.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    static let identifier = "CollectionCell"
    static func register() -> UINib {
        UINib(nibName: "CollectionCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator.startAnimating()
        layer.cornerRadius = 10
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 1
    }
    
    func configure(with collection: ItemViewModel) {
        imageView.sd_setImage(with: collection.image) { [weak self] _, _, _, _ in
            self?.activityIndicator.stopAnimating()
        }
    }

}
