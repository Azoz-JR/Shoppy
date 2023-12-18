//
//  ProductDetailView.swift
//  Shoppy
//
//  Created by Azoz Salah on 12/12/2023.
//

import UIKit

class ProductDetailView: UIView {
    
    let availableColors: [UIColor] = [.myBackground, .myGreen, .systemBlue, .systemPink]
    
    var imageView: UIImageView!
    var dismissButton: UIButton!
    var likeButton: UIButton!
    var contentView: UIView!
    var productLabel: UILabel!
    var ratingLabel: UILabel!
    var ratingView: UIStackView!
    var colorsLabel: UILabel!
    var colorsView: UIStackView!
    var descriptionLabel: UILabel!
    var descriptionText: UITextView!
    var priceLabel: UILabel!
    var addToCartButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .myBackground
        configureImageView()
        configureDismissButton()
        configureLikeButton()
        configureContentView()
        configureProductLabel()
        configureRatingLabel()
        configureRatingView()
        configureColorsLabel()
        configureColorButtons()
        configureCartButton()
        configurePriceLabel()
        configureDescriptionLabel()
        configureDescriptionText()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
    
    private func configureDismissButton() {
        dismissButton = UIButton(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
        dismissButton.layer.cornerRadius = dismissButton.frame.width / 2
        dismissButton.backgroundColor = .systemBackground
        dismissButton.tintColor = .label
        dismissButton.setImage(UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dismissButton)
        
        dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureLikeButton() {
        likeButton = UIButton()
        likeButton.tintColor = .label
        likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        likeButton.sizeToFit()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(likeButton)
        
        likeButton.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func configureContentView() {
        contentView = UIView()
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 30
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        contentView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -30).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func configureProductLabel() {
        productLabel = UILabel()
        productLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        productLabel.textColor = .label
        productLabel.numberOfLines = 0
        productLabel.textAlignment = .left
        productLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(productLabel)
        
        productLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        productLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        productLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6).isActive = true
        productLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func configureRatingLabel() {
        ratingLabel = UILabel()
        ratingLabel.text = "5.0"
        ratingLabel.textAlignment = .right
        ratingLabel.textColor = .systemOrange
        ratingLabel.numberOfLines = 1
        ratingLabel.font = .systemFont(ofSize: 14)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingLabel)
        
        ratingLabel.centerYAnchor.constraint(equalTo: productLabel.centerYAnchor).isActive = true
        ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    }
    
    private func configureRatingView() {
        ratingView = UIStackView()
        ratingView.distribution = .fillEqually
        ratingView.spacing = 0
        ratingView.alignment = .center
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingView)
        
        ratingView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor).isActive = true
        ratingView.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -2).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Create five star images
        for index in 0..<5 {
            let starImage = UIImageView()
            starImage.image = UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
            starImage.tintColor = .systemOrange
            starImage.tag = index
            starImage.sizeToFit()
            ratingView.addArrangedSubview(starImage)
        }
                
    }
    
    private func configureColorsLabel() {
        colorsLabel = UILabel()
        colorsLabel.text = "Colors"
        colorsLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        colorsLabel.textColor = .label
        colorsLabel.numberOfLines = 1
        colorsLabel.textAlignment = .left
        colorsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorsLabel)
        
        colorsLabel.topAnchor.constraint(equalTo: productLabel.bottomAnchor, constant: 5).isActive = true
        colorsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        colorsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
        colorsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureColorButtons() {
        colorsView = UIStackView()
        colorsView.distribution = .equalSpacing
        colorsView.spacing = 8
        colorsView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(colorsView)
        
        colorsView.topAnchor.constraint(equalTo: colorsLabel.bottomAnchor).isActive = true
        colorsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        colorsView.widthAnchor.constraint(equalToConstant: 144).isActive = true
        colorsView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let selectedColor = availableColors.first
        
        // Create circle buttons for each available color
        for (index, color) in availableColors.enumerated() {
            let colorButton = UIButton(type: .custom)
            colorButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            colorButton.backgroundColor = color
            colorButton.layer.cornerRadius = colorButton.frame.width / 2
            colorButton.layer.borderWidth = 2
            colorButton.layer.borderColor = color == selectedColor ? UIColor.label.cgColor : UIColor.systemBackground.cgColor
            
            // Set a tag to identify the color
            colorButton.tag = index
            colorsView.addArrangedSubview(colorButton)
        }
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel = UILabel()
        descriptionLabel.text = "Description"
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        descriptionLabel.textColor = .label
        descriptionLabel.numberOfLines = 1
        descriptionLabel.textAlignment = .left
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: colorsView.bottomAnchor, constant: 5).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureDescriptionText() {
        descriptionText = UITextView()
        descriptionText.textContainerInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        descriptionText.textColor = .secondaryLabel
        descriptionText.font = .systemFont(ofSize: 14)
        descriptionText.isEditable = false
        descriptionText.isScrollEnabled = true
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionText)
        
        descriptionText.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
        descriptionText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        descriptionText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        descriptionText.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -10).isActive = true
    }
    
    private func configureCartButton() {
        addToCartButton = UIButton(type: .custom)
        addToCartButton.backgroundColor = .myGreen
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.layer.cornerRadius = 20
        contentView.addSubview(addToCartButton)
        
        addToCartButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        addToCartButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45, constant: -15).isActive = true
        addToCartButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Add cart image
        let contentView = UIView()
        contentView.contentMode = .center
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.addSubview(contentView)
        
        let cartImage = UIImage(systemName: "cart")
        let cartImageView = UIImageView(image: cartImage)
        cartImageView.tintColor = .black
        cartImageView.contentMode = .scaleAspectFit
        
        // Add "Add to Cart" label
        let label = UILabel()
        label.text = "Add to cart"
        label.textColor = .black
        
        // Add image and label to the button
        contentView.addSubview(cartImageView)
        contentView.addSubview(label)
        
        // Set constraints for the contentView
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: addToCartButton.centerXAnchor)
        ])
        
        
        // Set constraints for the image
        cartImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cartImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cartImageView.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor),
            cartImageView.widthAnchor.constraint(equalToConstant: 24),
            cartImageView.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        // Set constraints for the label
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: cartImageView.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor),
        ])
    }
    
    private func configurePriceLabel() {
        priceLabel = UILabel()
        priceLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        priceLabel.textColor = .label
        priceLabel.numberOfLines = 1
        priceLabel.textAlignment = .left
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
        
        priceLabel.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: addToCartButton.leadingAnchor, constant: -10).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configure(with product: Product) {
        let url = URL(string: product.thumbnail)
        imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "hourglass.bottomhalf.filled"))
        
        productLabel.text = product.title
        descriptionText.text = product.description
        priceLabel.text = "\(product.price)$"
        ratingLabel.text = "\(product.rating)"
        setRating(rating: product.rating)
    }
    
    func setRating(rating: Double) {
        let rate = Int(rating.rounded())
        
        for (index, imageView) in ratingView.arrangedSubviews.enumerated() {
            if let imageView = imageView as? UIImageView {
                imageView.image = index < rate
                ? UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
                : UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
            }
        }
    }

}
