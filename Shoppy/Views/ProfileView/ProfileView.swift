//
//  ProfileView.swift
//  Shoppy
//
//  Created by Azoz Salah on 27/12/2023.
//

import UIKit

final class ProfileView: UIView {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    
    // Orders
    @IBOutlet var seeAllOrdersButton: UIButton!
    @IBOutlet var returnToHomeButton: UIButton!
    @IBOutlet var noOrdersLabel: UILabel!
    @IBOutlet var ordersCollection: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    //Lists
    @IBOutlet var listContainer: UIView!
    @IBOutlet var listNameLabel: UILabel!
    @IBOutlet var imagesStackView: UIStackView!
    @IBOutlet var seeAllListsButton: UIButton!
    @IBOutlet var createListButton: UIButton!
    @IBOutlet var noListsLabel: UILabel!
    @IBOutlet var itemsCountLabel: UILabel!
    
    //Buttons
    var returnToHomeHandler: (() -> Void)?
    var createListHandler: (() -> Void)?
    var seeAllOrdersHandler: (() -> Void)?
    var seeAllListsHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let view = loadFromNib() {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
        
        userImageView.layer.cornerRadius = 15
        
        listContainer.layer.cornerRadius = 10
        listContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        listContainer.layer.borderWidth = 1
        
        returnToHomeButton.layer.cornerRadius = 10
        returnToHomeButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        returnToHomeButton.layer.borderWidth = 1
        returnToHomeButton.addTarget(self, action: #selector(returnToHomeTapped), for: .touchUpInside)
        
        createListButton.layer.cornerRadius = 10
        createListButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        createListButton.layer.borderWidth = 1
        createListButton.addTarget(self, action: #selector(createListTapped), for: .touchUpInside)
        
        seeAllOrdersButton.addTarget(self, action: #selector(seeAllOrdersTapped), for: .touchUpInside)
        seeAllListsButton.addTarget(self, action: #selector(seeAllListsTapped), for: .touchUpInside)
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func loadFromNib() -> UIView? {
        let nib = UINib(nibName: "ProfileView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    
}


// MARK: Buttons methods
extension ProfileView {
    @objc func returnToHomeTapped() {
        returnToHomeHandler?()
    }
    
    @objc func createListTapped() {
        createListHandler?()
    }
    
    @objc func seeAllOrdersTapped() {
        seeAllOrdersHandler?()
    }
    
    @objc func seeAllListsTapped() {
        seeAllListsHandler?()
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        print("index: \(sender.currentPage)")
        let index = sender.currentPage
        ordersCollection.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
}

// MARK: Views Configurations
extension ProfileView {
    func configureOrder(with orders: [Order]) {
        guard !orders.isEmpty else {
            noOrdersConfiguration(value: true)
            pageControl.numberOfPages = 0
            return
        }
        noOrdersConfiguration(value: false)
        pageControl.numberOfPages = orders.count
        
    }
    
    func configureLists(with lists: [List]) {
        guard !lists.isEmpty, let list = lists.first else {
            noListsConfiguration(value: true)
            return
        }
        
        noListsConfiguration(value: false)
        listNameLabel.text = list.name
        itemsCountLabel.text = "Items: \(list.items.count)"
        
        guard !list.items.isEmpty else {
            noItemsConfiguration()
            return
        }
        configureListImages(items: list.items)
    }
    
    func noOrdersConfiguration(value: Bool) {
        ordersCollection.isHidden = value
        seeAllOrdersButton.isHidden = value
        
        noOrdersLabel.isHidden = !value
        returnToHomeButton.isHidden = !value
    }
    
    func noListsConfiguration(value: Bool) {
        listContainer.isHidden = value
        seeAllListsButton.isHidden = value
        
        noListsLabel.isHidden = !value
        createListButton.isHidden = !value
    }
    
    func configureListImages(items: [ItemViewModel]) {
        imagesStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        
        let count = items.count
        
        for (index, item) in items.enumerated() {
            let imageView = UIImageView()
            imageView.layer.cornerRadius = 10
            imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            imageView.layer.borderWidth = 1
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleToFill
            
            imageView.sd_setImage(with: item.image) {[weak self] _,_,_,_ in
                self?.imagesStackView.addArrangedSubview(imageView)
                NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalToConstant: 80),
                    imageView.heightAnchor.constraint(equalToConstant: 80)
                ])
            }
            
            if index == 1 && count > 2 {
                let remainingCount = count - 2
                let plusView = createPlusView(number: remainingCount)
                imagesStackView.addArrangedSubview(plusView)
                
                NSLayoutConstraint.activate([
                    plusView.widthAnchor.constraint(equalToConstant: 40),
                    plusView.heightAnchor.constraint(equalToConstant: 80)
                ])
                
                break
            }
        }
    }
    
    func noItemsConfiguration() {
        print("noItemsCalled")
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .center
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imagesStackView.addArrangedSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func createPlusView(number: Int) -> UIView {
        let plusView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 80))
        plusView.backgroundColor = .lightGray
        plusView.layer.cornerRadius = 10
        plusView.translatesAutoresizingMaskIntoConstraints = false

        
        let label = UILabel()
        label.text = "+\(number)"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        plusView.addSubview(label)
        
        // Add constraints for label within plusView
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: plusView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: plusView.centerYAnchor),
        ])
        
        return plusView
    }
}
