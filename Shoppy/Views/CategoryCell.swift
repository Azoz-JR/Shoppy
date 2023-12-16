//
//  CategoryCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet var productImageView: UIImageView!
    
    @IBOutlet var content: UIView!
    @IBOutlet var nameLabel: UILabel!
    
    static let identifier = "CategoryCell"
    static func register() -> UINib {
        UINib(nibName: "CategoryCell", bundle: nil)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    private func configureUI() {
        
        content.layer.cornerRadius = 100
        content.layer.maskedCorners = [.layerMaxXMaxYCorner]
        content.layer.borderColor = UIColor.lightGray.cgColor
        content.layer.borderWidth = 0.5
        backgroundColor = .systemBackground
        //productImageView.roundedCorners(corners: [.topRight, .bottomLeft], cornerRadius: 50)
        
    }
    
    func configure(with category: Category) {
        productImageView.image = UIImage(named: category.rawValue)
        nameLabel.text = category.rawValue.capitalized
    }
    
}
