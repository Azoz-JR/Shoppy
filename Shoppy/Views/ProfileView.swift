//
//  ProfileView.swift
//  Shoppy
//
//  Created by Azoz Salah on 27/12/2023.
//

import UIKit

class ProfileView: UIView {
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var orderContainer: UIView!
    @IBOutlet var orderName: UILabel!
    @IBOutlet var orderPrice: UILabel!
    @IBOutlet var orderDate: UILabel!
    @IBOutlet var orderImage: UIImageView!
    @IBOutlet var seeAllOrdersButton: UIButton!
    @IBOutlet var returnToHomeButton: UIButton!
    @IBOutlet var noOrdersLabel: UILabel!
    
    @IBOutlet var listContainer: UIView!
    @IBOutlet var listNameLabel: UILabel!
    @IBOutlet var imagesStackView: UIStackView!
    @IBOutlet var seeAllListsButton: UIButton!
    @IBOutlet var createListButton: UIButton!
    @IBOutlet var noListsLabel: UILabel!
    
    var returnToHomeHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let view = loadFromNib() {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
        
        orderContainer.layer.cornerRadius = 10
        orderContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        orderContainer.layer.borderWidth = 1
        
        listContainer.layer.cornerRadius = 10
        listContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        listContainer.layer.borderWidth = 1
        
        orderImage.layer.cornerRadius = 10
        orderImage.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        orderImage.layer.borderWidth = 1
        
        returnToHomeButton.layer.cornerRadius = 10
        returnToHomeButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        returnToHomeButton.layer.borderWidth = 1
        returnToHomeButton.addTarget(self, action: #selector(returnToHomeTapped), for: .touchUpInside)
        
        createListButton.layer.cornerRadius = 10
        createListButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        createListButton.layer.borderWidth = 1
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func loadFromNib() -> UIView? {
        let nib = UINib(nibName: "ProfileView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configureOrder(with orders: [Order]) {
        guard !orders.isEmpty, let order = orders.first else {
            noOrdersConfiguration(value: true)
            return
        }
        noOrdersConfiguration(value: false)
        
        orderName.text = order.items.map {$0.title}.joined(separator: ",")
        orderPrice.text = "\(order.price)$"
        orderDate.text = order.date.formatted(date: .abbreviated, time: .shortened)
        orderImage.sd_setImage(with: order.image)
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
        orderContainer.isHidden = value
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
    
}
