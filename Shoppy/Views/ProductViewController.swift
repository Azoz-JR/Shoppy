//
//  ProductViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 10/12/2023.
//

import SDWebImage
import UIKit

class ProductViewController: UIViewController {
    var product: Product? = nil
    
    
    var imageView: UIImageView!
    var dismissButton: UIButton!
    var likeButton: UIButton!
    var contentView: UIView!
    var productLabel: UILabel!
    var ratingView: UIStackView!
    var colorsLabel: UILabel!
    var colorsView: UIStackView!
    var descriptionLabel: UILabel!
    var descriptionText: UITextView!
    var priceLabel: UILabel!
    var addToCartButton: UIButton!
    
    var liked: Bool = false
    var availableColors: [UIColor] = [.myBackground, .myGreen, .systemBlue, .systemPink]
    var selectedColor: UIColor? {
            didSet {
                updateColorSelection()
            }
        }
    var rating: Int = 0 {
            didSet {
                updateRating()
            }
        }
    
    override func loadView() {
        super.loadView()
        
        imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        dismissButton = UIButton(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
        dismissButton.layer.cornerRadius = dismissButton.frame.width / 2
        dismissButton.backgroundColor = .systemBackground
        dismissButton.tintColor = .label
        dismissButton.setImage(UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dismissButton)
        
        likeButton = UIButton(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
        likeButton.tintColor = .label
        likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(likeButton)
        
        contentView = UIView()
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 30
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        productLabel = UILabel()
        productLabel.text = product?.title
        productLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        productLabel.textColor = .label
        productLabel.numberOfLines = 0
        productLabel.textAlignment = .left
        productLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(productLabel)
        
        setupRatingView()
        contentView.addSubview(ratingView)
        
        colorsLabel = UILabel()
        colorsLabel.text = "Colors"
        colorsLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        colorsLabel.textColor = .label
        colorsLabel.numberOfLines = 1
        colorsLabel.textAlignment = .left
        colorsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorsLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "Description"
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        descriptionLabel.textColor = .label
        descriptionLabel.numberOfLines = 1
        descriptionLabel.textAlignment = .left
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        setupColorButtons()
        contentView.addSubview(colorsView)
        
        descriptionText = UITextView()
        descriptionText.text = product?.description
        descriptionText.textContainerInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        descriptionText.textColor = .secondaryLabel
        descriptionText.font = .systemFont(ofSize: 14)
        descriptionText.isEditable = false
        descriptionText.isScrollEnabled = true
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionText)
        
        priceLabel = UILabel()
        priceLabel.text = "\(product?.price ?? 0.0)$"
        priceLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        priceLabel.textColor = .label
        priceLabel.numberOfLines = 1
        priceLabel.textAlignment = .left
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
        
        setupCartButton()
        contentView.addSubview(addToCartButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .myBackground
        
        if let product = product {
            let url = URL(string: product.thumbnail)
            imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "hourglass.bottomhalf.filled"))
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            dismissButton.widthAnchor.constraint(equalToConstant: 40),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            
            likeButton.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            
            contentView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -30),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            productLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            productLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            productLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
            productLabel.heightAnchor.constraint(equalToConstant: 50),
            
            ratingView.centerYAnchor.constraint(equalTo: productLabel.centerYAnchor),
            ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            ratingView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            ratingView.heightAnchor.constraint(equalToConstant: 40),
            
            colorsLabel.topAnchor.constraint(equalTo: productLabel.bottomAnchor, constant: 5),
            colorsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            colorsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            colorsLabel.heightAnchor.constraint(equalToConstant: 40),
            
            colorsView.topAnchor.constraint(equalTo: colorsLabel.bottomAnchor),
            colorsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            colorsView.widthAnchor.constraint(equalToConstant: 144),
            colorsView.heightAnchor.constraint(equalToConstant: 30),
            
            descriptionLabel.topAnchor.constraint(equalTo: colorsView.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            descriptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionText.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            descriptionText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            descriptionText.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -10),
            
            priceLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            priceLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.33),
            priceLabel.heightAnchor.constraint(equalToConstant: 40),
            
            addToCartButton.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            addToCartButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.35),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func likeButtonTapped() {
        liked.toggle()
        likeButton.tintColor = liked ? .myGreen : .label
        likeButton.setImage(UIImage(systemName: (liked ? "heart.fill" : "heart"), withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
    }
    
    private func setupRatingView() {
        ratingView = UIStackView()
        ratingView.distribution = .fillEqually
        ratingView.spacing = 8
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create five star buttons
        for index in 0..<5 {
            let starButton = UIButton()
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
            starButton.tintColor = .systemOrange
            starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
            starButton.tag = index
            ratingView.addArrangedSubview(starButton)
        }
                
    }
    
    @objc private func starButtonTapped(_ sender: UIButton) {
        // Update the rating based on the tapped star button
        rating = sender.tag + 1
    }
    
    private func updateRating() {
        // Set the selected state for star buttons based on the rating
        for (index, starButton) in ratingView.arrangedSubviews.enumerated() {
            if let button = starButton as? UIButton {
                button.isSelected = index < rating
            }
        }
    }
    
    private func setupColorButtons() {
        colorsView = UIStackView()
        colorsView.distribution = .equalSpacing
        colorsView.spacing = 8
        colorsView.translatesAutoresizingMaskIntoConstraints = false
        
        selectedColor = availableColors.first
        
        // Create circle buttons for each available color
        for (index, color) in availableColors.enumerated() {
            let colorButton = UIButton(type: .custom)
            colorButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            colorButton.backgroundColor = color
            colorButton.layer.cornerRadius = colorButton.frame.width / 2
            colorButton.layer.borderWidth = 2
            colorButton.layer.borderColor = color == selectedColor ? UIColor.label.cgColor : UIColor.systemBackground.cgColor
            colorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            
            // Set a tag to identify the color
            colorButton.tag = index
            colorsView.addArrangedSubview(colorButton)
        }
    }
    
    @objc private func colorButtonTapped(_ sender: UIButton) {
        // Update the selected color based on the tapped button
        selectedColor = availableColors[sender.tag]
    }
    
    private func updateColorSelection() {
        // Update the border color for all color buttons
        for case let button as UIButton in colorsView.arrangedSubviews {
            button.layer.borderColor = button.backgroundColor == selectedColor ? UIColor.label.cgColor : UIColor.systemBackground.cgColor
        }
    }
    
    private func setupCartButton() {
        addToCartButton = UIButton(type: .custom)
        addToCartButton.backgroundColor = .myGreen
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.layer.cornerRadius = 20
        
        // Add cart image
        let cartImage = UIImage(systemName: "cart")
        let cartImageView = UIImageView(image: cartImage)
        cartImageView.tintColor = .black
        cartImageView.contentMode = .scaleAspectFit
        
        // Add "Add to Cart" label
        let label = UILabel()
        label.text = "Add to cart"
        label.textColor = .black
        
        // Add image and label to the button
        addToCartButton.addSubview(cartImageView)
        addToCartButton.addSubview(label)
        
        // Set constraints for the image
        cartImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cartImageView.leadingAnchor.constraint(equalTo: addToCartButton.leadingAnchor, constant: 8),
            cartImageView.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor),
            cartImageView.widthAnchor.constraint(equalToConstant: 24),
            cartImageView.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        // Set constraints for the label
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: cartImageView.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: addToCartButton.trailingAnchor, constant: -8),
            label.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor),
        ])
    }
    
    @objc func addToCartButtonTapped() {
        
    }
    
    
}
