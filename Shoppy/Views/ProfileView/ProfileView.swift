//
//  ProfileView.swift
//  Shoppy
//
//  Created by Azoz Salah on 27/12/2023.
//

import UIKit

final class ProfileView: UIView {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var seeAllOrdersButton: UIButton!
    @IBOutlet var returnToHomeButton: UIButton!
    @IBOutlet var noOrdersLabel: UILabel!
    @IBOutlet var ordersCollection: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var listContainer: UIView!
    @IBOutlet var listNameLabel: UILabel!
    @IBOutlet var imagesStackView: UIStackView!
    @IBOutlet var seeAllListsButton: UIButton!
    @IBOutlet var createListButton: UIButton!
    @IBOutlet var noListsLabel: UILabel!
    
    var returnToHomeHandler: (() -> Void)?
    var seeAllOrdersHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let view = loadFromNib() {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
        
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
        
        seeAllOrdersButton.addTarget(self, action: #selector(seeAllOrdersTapped), for: .touchUpInside)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func loadFromNib() -> UIView? {
        let nib = UINib(nibName: "ProfileView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configureOrder(with orders: [Order]) {
        guard !orders.isEmpty else {
            noOrdersConfiguration(value: true)
            pageControl.numberOfPages = 0
            return
        }
        noOrdersConfiguration(value: false)
        pageControl.numberOfPages = orders.count
        
    }
    
    func configureList(with lists: [List]) {
        guard !lists.isEmpty, let list = lists.first else {
            noListsConfiguration(value: true)
            return
        }
        
        noListsConfiguration(value: false)
        listNameLabel.text = list.name
        list.items.forEach { item in
            let imageView = UIImageView()
            imageView.sd_setImage(with: item.image) {[weak self] _,_,_,_ in
                self?.imagesStackView.addArrangedSubview(imageView)
            }
        }
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
    
    @objc func returnToHomeTapped() {
        returnToHomeHandler?()
    }
    
    @objc func seeAllOrdersTapped() {
        seeAllOrdersHandler?()
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        print("index: \(sender.currentPage)")
        let index = sender.currentPage
        ordersCollection.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
}
