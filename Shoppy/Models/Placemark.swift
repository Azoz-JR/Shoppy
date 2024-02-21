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
    
    var text: String {
        var finalText = "Deliver to: "
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
