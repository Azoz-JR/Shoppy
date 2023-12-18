//
//  ProductCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 08/12/2023.
//

import SDWebImage
import UIKit

class ProductCell: UICollectionViewCell {
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var productLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var addToCartButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var liked: Bool = false
    var addToCartHandler: (() -> Void)?
    
    static let identifier = "ProductCell"
    static func register() -> UINib {
        UINib(nibName: "ProductCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        backgroundColor = .myBackground
        layer.cornerRadius = 20
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.lightGray.cgColor
        
        productImageView.roundedCorners(corners: [.topLeft, .topRight], cornerRadius: 20)
        
        addToCartButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addToCartButton.roundedCorners(corners: [.topLeft, .bottomRight], cornerRadius: 20)
        
        likeButton.setImage(UIImage(systemName: (liked ? "heart.fill" : "heart"), withConfiguration: UIImage.SymbolConfiguration(pointSize: 18)), for: .normal)
        likeButton.sizeToFit()
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        activityIndicator.startAnimating()
    }
    
    func configure(with product: Product) {
        let url = URL(string: product.thumbnail)
        productImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
            self?.activityIndicator.stopAnimating()
        }
        productLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        ratingLabel.text = "\(product.rating)"
    }
    
    @objc func likeButtonTapped() {
        liked.toggle()
        likeButton.tintColor = liked ? .myGreen : .black
        likeButton.setImage(UIImage(systemName: (liked ? "heart.fill" : "heart"), withConfiguration: UIImage.SymbolConfiguration(pointSize: 18)), for: .normal)
    }
    
    @objc func addButtonTapped() {
        addToCartHandler?()
    }

    
}

