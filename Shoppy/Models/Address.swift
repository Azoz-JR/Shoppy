//
//  Address.swift
//  Shoppy
//
//  Created by Azoz Salah on 20/02/2024.
//

import Foundation
import MapKit

class Address: Codable {
    var name: String
    var phone: String
    var street: String
    var building: String
    var floor: String
    var area: String
    var city: String
    var country: String
    var location: Location?
    
    init(name: String = "", phone: String = "", street: String = "", building: String = "", floor: String = "", area: String = "", city: String = "", country: String = "", location: Location? = nil) {
        self.name = name
        self.phone = phone
        self.street = street
        self.building = building
        self.floor = floor
        self.area = area
        self.city = city
        self.country = country
        self.location = location
    }
}
