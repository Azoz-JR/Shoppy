//
//  ProductCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 08/12/2023.
//

import SDWebImage
import UIKit

class ProductCell: UICollectionViewCell {
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .lightGray.withAlphaComponent(0.98)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
        button.layer.cornerRadius = button.frame.width / 2
        button.backgroundColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let plusLabel = UILabel(frame: button.bounds)
        plusLabel.text = "+"
        plusLabel.textColor = .systemBackground
        plusLabel.textAlignment = .center
        plusLabel.font = UIFont.systemFont(ofSize: 24)
        button.addSubview(plusLabel)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 20
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(productImageView)
        addSubview(overlayView)
        addSubview(addButton)
        overlayView.addSubview(nameLabel)
        overlayView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            // Product Image View Constraints
            productImageView.topAnchor.constraint(equalTo: topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            // Overlay View Constraints
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlayView.heightAnchor.constraint(equalToConstant: 60),
            
            // Name Label Constraints
            nameLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -8),
            nameLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 8),
            
            // Price Label Constraints
            priceLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -8),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -8),
            
            addButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -10),
            addButton.widthAnchor.constraint(equalToConstant: 40),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with product: Product) {
        let url = URL(string: product.thumbnail)
        productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "me"))
        nameLabel.text = product.title
        priceLabel.text = "$\(product.price)"
    }
    
}

