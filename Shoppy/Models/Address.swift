//
//  Address.swift
//  Shoppy
//
//  Created by Azoz Salah on 20/02/2024.
//

import Foundation
import MapKit

class Address: Codable, Equatable {
    var id: String = UUID().uuidString
    var name: String
    var phone: String
    var street: String
    var building: String
    var floor: String
    var area: String
    var landmark: String?
    var location: Location?
    
    init(name: String = "", phone: String = "", street: String = "", building: String = "", floor: String = "", area: String = "", landmark: String? = nil, location: Location? = nil) {
        self.name = name
        self.phone = phone
        self.street = street
        self.building = building
        self.floor = floor
        self.area = area
        self.landmark = landmark
        self.location = location
    }
    
    var text: String {
        var finalText = ""
        var strings = [String]()
        
        if !building.isEmpty {
            strings.append(building)
        }
        
        if !street.isEmpty {
            strings.append(street)
        }
        
        if !area.isEmpty {
            strings.append(area)
        }
        
        if !city.isEmpty {
            strings.append(city)
        }
        
        return finalText + strings.joined(separator: ", ")
    }
    
    var city: String {
        location?.placemark?.administrativeArea ?? "Unknown"
    }
    
    var country: String {
        location?.placemark?.country ?? "Unknown"
    }
    
    static func ==(lhs: Address, rhs: Address) -> Bool {
        lhs.id == rhs.id
    }
}
