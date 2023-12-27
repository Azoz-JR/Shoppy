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
    
    @IBOutlet var listContainer: UIView!
    @IBOutlet var listNameLabel: UILabel!
    @IBOutlet var imagesStackView: UIStackView!
    
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
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func loadFromNib() -> UIView? {
        let nib = UINib(nibName: "ProfileView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configureOrder(with order: Order) {
        orderName.text = order.items.map {$0.title}.joined(separator: ",")
        orderPrice.text = "\(order.price)$"
        orderDate.text = order.date.formatted(date: .abbreviated, time: .shortened)
        orderImage.sd_setImage(with: order.image)
    }
    
    func configureListWith() {
        
    }
    
}
