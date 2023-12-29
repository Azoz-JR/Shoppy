//
//  ProductViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 10/12/2023.
//

import SDWebImage
import UIKit

final class ProductViewController: UIViewController {
    var product: ItemViewModel? = nil
    var productsViewModel: ProductsViewModel
    var productView = ProductDetailView()
    
    init(product: ItemViewModel? = nil, productsViewModel: ProductsViewModel) {
        self.product = product
        self.productsViewModel = productsViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var liked = false {
        didSet {
            updateLikeButton(value: liked)
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
        
        liked = productsViewModel.likedProducts.value?.contains(product) ?? false
        productView.configure(with: product)
        configButtons()
    }
    
    func configButtons() {
        productView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        productView.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        productView.addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        
        for case let colorButton as UIButton in productView.colorsView.arrangedSubviews {
            colorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        }
        
    }
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func likeButtonTapped() {
        guard let product else {
            return
        }
        
        productsViewModel.likeProduct(product: product)
        liked.toggle()
        updateLikeButton(value: liked)
    }
    
    
    @objc private func colorButtonTapped(_ sender: UIButton) {
        // Update the selected color based on the tapped button
        selectedColor = productView.availableColors[sender.tag]
    }
    
    private func updateColorSelection() {
        // Update the border color for all color buttons
        for case let button as UIButton in productView.colorsView.arrangedSubviews {
            button.layer.borderColor = button.backgroundColor == selectedColor ? UIColor.lightGray.cgColor : UIColor.clear.cgColor
        }
    }
    
    @objc func addToCartButtonTapped() {
        guard let productViewModel = product else {
            return
        }
        productsViewModel.addProduct(product: productViewModel)
        showAddedSuccessfulyAlert()
    }
    
    func updateLikeButton(value: Bool) {
        productView.likeButton.setImage(UIImage(systemName: (value ? "heart.fill" : "heart"), withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
    }
    
    
}
