//
//  ProductViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 10/12/2023.
//

import SDWebImage
import UIKit

final class ProductViewController: UIViewController {
    var product: ItemModel? = nil
    var cartViewModel: CartViewModel
    var listsViewModel: ListsViewModel
    var wishListViewModel: WishListViewModel
    var likeButton: UIBarButtonItem!
    
    var productView = ProductDetailView()
    
    init(product: ItemModel? = nil, cartViewModel: CartViewModel, listsViewModel: ListsViewModel, wishListViewModel: WishListViewModel) {
        self.product = product
        self.cartViewModel = cartViewModel
        self.listsViewModel = listsViewModel
        self.wishListViewModel = wishListViewModel
        
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
        liked = wishListViewModel.isLiked(product: product)
        productView.configure(with: product)
        configButtons()
        selectedColor = productView.availableColors.first
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
        
        wishListViewModel.likeProduct(product: product)
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
        guard var product, let selectedColor else {
            return
        }
        
        product.selectColor(color: selectedColor.accessibilityName)
        product.selectSize(size: productView.selectedSize)
        
        cartViewModel.addProduct(product: product) { [weak self] error in
            if let error {
                self?.show(error: error)
                return
            }
            
            self?.showAddedSuccessfulyAlert()
        }
        
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
