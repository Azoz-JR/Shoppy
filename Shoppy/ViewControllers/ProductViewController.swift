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
    var productView = ProductDetailView()
    
    var liked = false
    
    var rating: Int = 0 {
            didSet {
                updateRating()
            }
        }
    
    var selectedColor: UIColor? {
            didSet {
                updateColorSelection()
            }
        }
    
    override func loadView() {
        super.loadView()
        
        view = productView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let product = product else {
            return
        }
        
        productView.configure(with: product)
        configButtons()
    }
    
    func configButtons() {
        productView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        productView.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        productView.addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        
        for case let starButton as UIButton in productView.ratingView.arrangedSubviews {
            starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
        }
        
        for case let colorButton as UIButton in productView.colorsView.arrangedSubviews {
            colorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        }
        
    }
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func likeButtonTapped() {
        liked.toggle()
        productView.likeButton.tintColor = liked ? .myGreen : .label
        productView.likeButton.setImage(UIImage(systemName: (liked ? "heart.fill" : "heart"), withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
    }
    
    @objc private func starButtonTapped(_ sender: UIButton) {
        // Update the rating based on the tapped star button
        rating = sender.tag + 1
    }
    
    private func updateRating() {
        // Set the selected state for star buttons based on the rating
        for (index, starButton) in productView.ratingView.arrangedSubviews.enumerated() {
            if let button = starButton as? UIButton {
                button.isSelected = index < rating
            }
        }
    }
    
    @objc private func colorButtonTapped(_ sender: UIButton) {
        // Update the selected color based on the tapped button
        selectedColor = productView.availableColors[sender.tag]
    }
    
    private func updateColorSelection() {
        // Update the border color for all color buttons
        for case let button as UIButton in productView.colorsView.arrangedSubviews {
            button.layer.borderColor = button.backgroundColor == selectedColor ? UIColor.label.cgColor : UIColor.systemBackground.cgColor
        }
    }
    
    @objc func addToCartButtonTapped() {
        
    }
    
    
}
