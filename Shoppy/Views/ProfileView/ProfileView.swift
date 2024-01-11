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
    @IBOutlet var scrollView: UIScrollView!
    
    // Orders
    @IBOutlet var seeAllOrdersButton: UIButton!
    @IBOutlet var returnToHomeButton: UIButton!
    @IBOutlet var noOrdersLabel: UILabel!
    @IBOutlet var ordersCollection: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    //Lists
    @IBOutlet var listsPageControl: UIPageControl!
    @IBOutlet var listsCollection: UICollectionView!
    @IBOutlet var imagesStackView: UIStackView!
    @IBOutlet var seeAllListsButton: UIButton!
    @IBOutlet var createListButton: UIButton!
    @IBOutlet var noListsLabel: UILabel!
    
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


// MARK: - Buttons methods
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
        let index = sender.currentPage
        ordersCollection.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func listsPageControlTapped(_ sender: UIPageControl) {
        let index = sender.currentPage
        listsCollection.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
}


// MARK: - Views Configurations
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
        listsPageControl.numberOfPages = lists.count
    }
    
    func noOrdersConfiguration(value: Bool) {
        ordersCollection.isHidden = value
        seeAllOrdersButton.isHidden = value
        
        noOrdersLabel.isHidden = !value
        returnToHomeButton.isHidden = !value
    }
    
    func noListsConfiguration(value: Bool) {
        listsCollection.isHidden = value
        seeAllListsButton.isHidden = value
        
        noListsLabel.isHidden = !value
        createListButton.isHidden = !value
    }
    
}
