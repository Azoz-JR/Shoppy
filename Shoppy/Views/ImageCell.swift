//
//  ImageCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 20/12/2023.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    static let identifier = "ImageCell"
    
    static func register() -> UINib {
        UINib(nibName: "ImageCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        
    }
}
