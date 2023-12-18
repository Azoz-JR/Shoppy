//
//  SmallCategoryCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 17/12/2023.
//

import UIKit

class SmallCategoryCell: UICollectionViewCell {
    @IBOutlet var content: UIView!
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var categoryLabel: UILabel!
    
    var categoryButtonHandler: (() -> Void)?
    
    static let identifier = "SmallCategoryCell"
    static func register() -> UINib {
        UINib(nibName: "SmallCategoryCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    private func configureUI() {
        
        layer.cornerRadius = 5
        categoryImageView.layer.cornerRadius = 5
    }
    
    func configure(with category: Category) {
        categoryImageView.image = UIImage(named: category.rawValue)
        categoryLabel.text = category.rawValue.capitalized
    }
    
    override var isSelected: Bool {
        didSet {
            content.backgroundColor = isSelected ? .label : .myBackground
            categoryLabel.textColor = isSelected ? .systemBackground : .black
        }
    }

}
