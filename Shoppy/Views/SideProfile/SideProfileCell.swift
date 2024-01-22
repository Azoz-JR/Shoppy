//
//  SideProfileCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 22/01/2024.
//

import UIKit

class SideProfileCell: UITableViewCell {
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellLabel: UILabel!
    
    static let identifier = "SideProfileCell"
    static func register() -> UINib {
        UINib(nibName: "SideProfileCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(label: String, image: UIImage?) {
        cellLabel.text = label
        cellImage.image = image
        
        if label == "Wish list" {
            cellImage.tintColor = .systemRed
        }
    }
    
}
