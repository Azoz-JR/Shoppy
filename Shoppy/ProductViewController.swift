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
    var listsViewModel: ListsViewModel
    var likeButton: UIBarButtonItem!
    
    var productView = ProductDetailView()
    
    init(product: ItemViewModel? = nil, productsViewModel: ProductsViewModel, listsViewModel: ListsViewModel) {
        self.product = product
        self.productsViewModel = productsViewModel
        self.listsViewModel = listsViewModel
        
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
        
        configureLikeButton()
        liked = listsViewModel.isLiked(product: product)
        productView.configure(with: product)
        configButtons()
    }
    
    private func configureLikeButton() {
        let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        likeButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(likeButtonTapped))
        likeButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = likeButton
    }
    
    func configButtons() {
        productView.addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        
        for case let colorButton as UIButton in productView.colorsView.arrangedSubviews {
            colorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        }
        
        productView.addToListButton.addTarget(self, action: #selector(addToListTapped), for: .touchUpInside)
        
    }
    
    @objc func addToListTapped() {
        guard let product else {
            return
        }
        
        let vc = ListSelectionViewController(item: product, listsViewModel: listsViewModel)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func likeButtonTapped() {
        guard let product else {
            return
        }
        
        listsViewModel.likeProduct(product: product)
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
        likeButton.image = UIImage(systemName: (value ? "heart.fill" : "heart"), withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .clear
        navigationController?.navigationBar.backgroundColor = .clear
    }
}
