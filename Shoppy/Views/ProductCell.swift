//
//  ProductCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 08/12/2023.
//

import SDWebImage
import UIKit

class ProductCell: UICollectionViewCell {
    
    var liked: Bool = false
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let spinnerView = UIActivityIndicatorView(style: .medium)
        spinnerView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        spinnerView.color = .systemGray
        spinnerView.startAnimating()
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        
        return spinnerView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        button.setImage(UIImage(systemName: "cart"), for: .normal)
        button.imageView?.tintColor = .black
        button.backgroundColor = .myGreen
        button.contentMode = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Create a custom path with rounded corners for the top leading and bottom trailing
        button.roundedCorners(corners: [.topLeft, .bottomRight], cornerRadius: 20)
        
        return button
    }()
    
    private var likeButton: UIButton = {
        let likeButton = UIButton(frame: CGRect(x: 12, y: 12, width: 24, height: 24))
        likeButton.tintColor = .black
        likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        return likeButton
    }()
    
    private var ratingView: UIStackView = {
        let ratingView = UIStackView()
        ratingView.distribution = .equalSpacing
        ratingView.alignment = .center
        ratingView.spacing = 2
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.axis = .horizontal
        return ratingView
    }()
    
    private var ratingLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemOrange
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
        backgroundColor = .myBackground
        layer.cornerRadius = 20
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.lightGray.cgColor
        
        addSubview(productImageView)
        addSubview(addButton)
        addSubview(likeButton)
        addSubview(activityIndicator)
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(ratingView)
        
        setUpRatingView()
        
        productImageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 0.7)
        productImageView.roundedCorners(corners: [.topLeft, .topRight], cornerRadius: 20)
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Product Image View Constraints
            productImageView.topAnchor.constraint(equalTo: topAnchor),
            productImageView.widthAnchor.constraint(equalTo: widthAnchor),
            productImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            
            likeButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -5),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -16),
            
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            priceLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            priceLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            ratingView.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            ratingView.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -5),
            ratingView.widthAnchor.constraint(equalToConstant: 40),
            ratingView.heightAnchor.constraint(equalToConstant: 20),
            
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
    }
    
    func configure(with product: Product) {
        let url = URL(string: product.thumbnail)
        productImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
            self?.activityIndicator.removeFromSuperview()
        }
        nameLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        ratingLabel.text = "\(product.rating)"
    }
    
    func setUpRatingView() {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12)))
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleToFill
        ratingView.addArrangedSubview(imageView)
        ratingView.addArrangedSubview(ratingLabel)
    }
    
    @objc func likeButtonTapped() {
        liked.toggle()
        likeButton.tintColor = liked ? .myGreen : .black
        likeButton.setImage(UIImage(systemName: (liked ? "heart.fill" : "heart"), withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
    }
    
}

