//
//  CategoryCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
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
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(productImageView)
        addSubview(overlayView)
        overlayView.addSubview(nameLabel)
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 20
        
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
            overlayView.heightAnchor.constraint(equalToConstant: 40),
            
            // Name Label Constraints
            nameLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -8),
            nameLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        ])
    }
    
    func configure(with category: Category) {
        productImageView.image = UIImage(named: category.rawValue)
        nameLabel.text = category.rawValue.capitalized
    }
    
}
