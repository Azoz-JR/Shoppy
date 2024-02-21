//
//  AddressTableViewCell.swift
//  Shoppy
//
//  Created by Azoz Salah on 20/02/2024.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var streetLabel: UILabel!
    @IBOutlet var buildingNumberLabel: UILabel!
    @IBOutlet var areaLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var deliverToThisAddressButton: UIButton!
    @IBOutlet var editAddressButton: UIButton!
    @IBOutlet var addressContainer: UIView!
    
    var selectAddressHandler: (() -> Void)?
    var editAddressHandler: (() -> Void)?
    
    
    static let identifier = "AddressCell"
    static func register() -> UINib {
        UINib(nibName: "AddressTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addressContainer.round(20)
        addressContainer.addBorder(color: .lightGray.withAlphaComponent(0.5), width: 1)
        
        deliverToThisAddressButton.addTarget(self, action: #selector(selectAddressTapped), for: .touchUpInside)
        editAddressButton.addTarget(self, action: #selector(editAddressTapped), for: .touchUpInside)
    }
    
    func configure(with address: Address) {
        nameLabel.text = address.name
        streetLabel.text  = address.street
        buildingNumberLabel.text = address.building
        areaLabel.text = address.area
        countryLabel.text = address.country
        phoneLabel.text = address.phone
    }
    
    @objc func selectAddressTapped() {
        selectAddressHandler?()
    }
    
    @objc func editAddressTapped() {
        editAddressHandler?()
    }
    
}
