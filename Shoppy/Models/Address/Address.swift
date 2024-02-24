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
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case phone
        case street
        case building
        case floor
        case area
        case landmark
        case location
    }
    
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.phone, forKey: .phone)
        try container.encode(self.street, forKey: .street)
        try container.encode(self.building, forKey: .building)
        try container.encode(self.floor, forKey: .floor)
        try container.encode(self.area, forKey: .area)
        try container.encodeIfPresent(self.landmark, forKey: .landmark)
        try container.encodeIfPresent(self.location, forKey: .location)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.street = try container.decode(String.self, forKey: .street)
        self.building = try container.decode(String.self, forKey: .building)
        self.floor = try container.decode(String.self, forKey: .floor)
        self.area = try container.decode(String.self, forKey: .area)
        self.landmark = try container.decodeIfPresent(String.self, forKey: .landmark)
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
    }
    
    
    var text: String {
        let finalText = ""
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
