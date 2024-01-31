//
//  SalesCollectionCellView.swift
//  Shoppy
//
//  Created by Azoz Salah on 31/01/2024.
//

import UIKit

class SalesCollectionCellView: UICollectionViewCell {
    @IBOutlet var saleImageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    static let identifier = "SalesCollectionCell"
    
    static func register() -> UINib {
        UINib(nibName: "SalesCollectionCellView", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        saleImageView.round(20)
        activityIndicator.startAnimating()
    }

}
