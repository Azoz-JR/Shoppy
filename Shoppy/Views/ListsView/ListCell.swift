//
//  ListCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 30/12/2023.
//

import UIKit

class ListCell: UITableViewCell {
    @IBOutlet var listContainer: UIView!
    @IBOutlet var listNameLabel: UILabel!
    @IBOutlet var listImage: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    static let identifier = "ListCell"
    static func register() -> UINib {
        UINib(nibName: "ListCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        listContainer.layer.cornerRadius = 20
        listContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        listContainer.layer.borderWidth = 1
        
        activityIndicator.startAnimating()
    }
    
    func configure(with list: List) {
        listNameLabel.text = list.name
        
        guard let image = list.items.first?.image else {
            return
        }
        listImage.sd_setImage(with: image) { [weak self] _, _, _, _ in
            self?.activityIndicator.stopAnimating()
        }
    }
    
}
