//
//  Placemark.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/02/2024.
//

import Foundation
import MapKit

struct Placemark: Codable {
    let name: String
    let throughfare: String
    let subThroughfare: String
    let locality: String
    let subLocality: String
    let administrativeArea: String
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case throughfare = "throughfare"
        case subThroughfare = "sub_throughfare"
        case locality = "locality"
        case subLocality = "sub_locality"
        case administrativeArea = "administrative_area"
        case country = "country"
    }
    
    init(name: String, throughfare: String, subThroughfare: String, locality: String, subLocality: String, administrativeArea: String, country: String) {
        self.name = name
        self.throughfare = throughfare
        self.subThroughfare = subThroughfare
        self.locality = locality
        self.subLocality = subLocality
        self.administrativeArea = administrativeArea
        self.country = country
    }
    
    init(placemark: CLPlacemark) {
        name = placemark.name ?? ""
        throughfare = placemark.thoroughfare ?? ""
        subThroughfare = placemark.subThoroughfare ?? ""
        locality = placemark.locality ?? ""
        subLocality = placemark.subLocality ?? ""
        administrativeArea = placemark.administrativeArea ?? ""
        country = placemark.country ?? ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.throughfare, forKey: .throughfare)
        try container.encode(self.subThroughfare, forKey: .subThroughfare)
        try container.encode(self.locality, forKey: .locality)
        try container.encode(self.subLocality, forKey: .subLocality)
        try container.encode(self.administrativeArea, forKey: .administrativeArea)
        try container.encode(self.country, forKey: .country)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.throughfare = try container.decode(String.self, forKey: .throughfare)
        self.subThroughfare = try container.decode(String.self, forKey: .subThroughfare)
        self.locality = try container.decode(String.self, forKey: .locality)
        self.subLocality = try container.decode(String.self, forKey: .subLocality)
        self.administrativeArea = try container.decode(String.self, forKey: .administrativeArea)
        self.country = try container.decode(String.self, forKey: .country)
    }
    
    var text: String {
        let finalText = "Deliver to: "
        var strings = [String]()
        
        if !subThroughfare.isEmpty {
            strings.append(subThroughfare)
        }
        
        if !throughfare.isEmpty {
            strings.append(throughfare)
        }
        
        if !subLocality.isEmpty {
            strings.append(subLocality)
        }
        
        if !locality.isEmpty {
            strings.append(locality)
        }
        
        return finalText + strings.joined(separator: ", ")
    }
    
}
