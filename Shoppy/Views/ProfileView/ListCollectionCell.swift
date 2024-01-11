//
//  ListCollectionCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 11/01/2024.
//

import UIKit

class ListCollectionCell: UICollectionViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var listNameLabel: UILabel!
    @IBOutlet var imagesStackView: UIStackView!
    @IBOutlet var itemsCountLabel: UILabel!
    
    static let identifier = "ListCollectionCell"
    static func register() -> UINib {
        UINib(nibName: "ListCollectionCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.round(10)
        containerView.addBorder(color: .lightGray.withAlphaComponent(0.5), width: 1)
    }
    
    func configure(with list: List) {
        listNameLabel.text = list.name
        itemsCountLabel.text = "Items: \(list.items.count)"
        
        guard !list.items.isEmpty else {
            noItemsConfiguration()
            return
        }
        configureListImages(items: list.items)
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
    
    func noItemsConfiguration() {
        imagesStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }

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

}
