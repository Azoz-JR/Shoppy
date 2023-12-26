//
//  ProductDetailView.swift
//  Shoppy
//
//  Created by Azoz Salah on 12/12/2023.
//

import UIKit

class ProductDetailView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    @IBOutlet var contentView: UIView!
    @IBOutlet var addToCartButton: UIButton!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var productLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var colorsView: UIStackView!
    @IBOutlet var sizesView: UIStackView!
    @IBOutlet var ratingView: UIStackView!
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var dismissButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    var images: [URL?] = []
    var availableColors: [UIColor] = []
    var availableSizes: [String] = []
    var selectedSize: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let view = loadFromNib() {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
        
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 0.4
        
        configureLikeButton()
        configureContentView()
        configureRatingView()
        configurePriceLabel()
        configureDescriptionText()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func loadFromNib() -> UIView? {
        let nib = UINib(nibName: "ProductDetailView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.register(), forCellWithReuseIdentifier: ImageCell.identifier)
        
        pageControl.currentPage = 0
    }
    
    private func configureLikeButton() {
        likeButton.tintColor = .label
        likeButton.sizeToFit()
    }
    
    private func configureContentView() {
        contentView.layer.cornerRadius = 30
    }
    
    private func configureRatingView() {
        ratingView.distribution = .fillEqually
        ratingView.spacing = 0
        ratingView.alignment = .center
    }
    
    private func configureColorButtons() {
        let width = availableColors.count * 30 + (availableColors.count - 1) * 8
        colorsView.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        
        let selectedColor = availableColors.first
        
        // Create circle buttons for each available color
        for (index, color) in availableColors.enumerated() {
            let colorButton = UIButton(type: .custom)
            colorButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            colorButton.backgroundColor = color
            colorButton.layer.cornerRadius = colorButton.frame.width / 2
            colorButton.layer.borderWidth = 2
            colorButton.layer.borderColor = color == selectedColor ? UIColor.lightGray.cgColor : UIColor.clear.cgColor
            
            // Set a tag to identify the color
            colorButton.tag = index
            colorsView.addArrangedSubview(colorButton)
        }
    }
    
    private func configureSizesButtons() {
        let width = availableSizes.count * 30 + (availableSizes.count - 1) * 5
        sizesView.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        
        
        // Create circle buttons for each available color
        for (index, size) in availableSizes.enumerated() {
            let sizeButton = UIButton(type: .system)
            sizeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            sizeButton.setTitle(size, for: .normal)
            sizeButton.tintColor = .label
            sizeButton.addTarget(self, action: #selector(sizeTapped), for: .touchUpInside)
            sizeButton.layer.cornerRadius = sizeButton.frame.width / 2
            sizeButton.layer.borderWidth = 1
            sizeButton.layer.borderColor = index == selectedSize ? UIColor.lightGray.cgColor : UIColor.clear.cgColor
            
            // Set a tag to identify the color
            sizeButton.tag = index
            sizesView.addArrangedSubview(sizeButton)
        }
    }
    
    private func configureDescriptionText() {
        descriptionText.textContainerInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        descriptionText.textColor = .secondaryLabel
        descriptionText.font = .systemFont(ofSize: 14)
        descriptionText.isEditable = false
        descriptionText.isScrollEnabled = true
    }
    
    private func configurePriceLabel() {
        priceLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        priceLabel.textColor = .label
        priceLabel.numberOfLines = 1
        priceLabel.textAlignment = .left
    }
    
    func configure(with product: ItemViewModel) {
        productLabel.text = product.title
        descriptionText.text = product.description
        priceLabel.text = "\(product.price)$"
//        ratingLabel.text = "\(product.rating)"
//        setRating(rating: product.rating)
        ratingLabel.text = "5"
        setRating(rating: 5)
        
        images = product.images
        pageControl.numberOfPages = product.images.count
        
        let colors = product.colors.map { $0.color }
        availableColors = colors
        configureColorButtons()
        availableSizes = product.sizes
        print(availableSizes)
        configureSizesButtons()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell {
            cell.imageView.sd_setImage(with: images[indexPath.row]) { _, _, _, _ in
                cell.activityIndicator.stopAnimating()
            }
            return cell
        }
        fatalError("Unable to dequeue ImageCell")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = (scrollView.contentOffset.x / scrollView.frame.width).rounded()
        pageControl.currentPage = Int(pageIndex)
    }
    
    @objc func sizeTapped(_ sender: UIButton) {
        selectedSize = sender.tag
        sizeSelected(at: selectedSize)
    }
    
    private func sizeSelected(at index: Int) {
        for case let button as UIButton in sizesView.arrangedSubviews {
            if button.tag == index {
                button.layer.borderColor = UIColor.lightGray.cgColor
            } else {
                button.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }


    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        let index = sender.currentPage
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
}
