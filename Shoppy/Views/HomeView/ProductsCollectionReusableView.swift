//
//  ProductsCollectionReusableView.swift
//  Shoppy
//
//  Created by Azoz Salah on 07/01/2024.
//

import UIKit

class ProductsCollectionReusableView: UICollectionReusableView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var seeMoreButton: UIButton!
    
    var seeMoreHandler: (() -> Void)?
    
    static let identifier = "ProductsHeader"
    static func register() -> UINib {
        UINib(nibName: "ProductsCollectionReusableView", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        seeMoreButton.addTarget(self, action: #selector(seeMoreTapped), for: .touchUpInside)
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    @objc func seeMoreTapped() {
        seeMoreHandler?()
    }
    
}
