//
//  Address.swift
//  Shoppy
//
//  Created by Azoz Salah on 20/02/2024.
//

import Foundation
import MapKit

struct Address: Codable {
    let name: String
    let phone: String
    let location: Location
    let placemark: String
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    
    init(clLocation: CLLocationCoordinate2D) {
        self.latitude = clLocation.latitude
        self.longitude = clLocation.longitude
    }
    
    var clLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct Placemark: Codable {
    let name: String
    let throughfare: String
    let locality: String
    let administrativeArea: String
    let country: String
    
    init(name: String, throughfare: String, locality: String, administrativeArea: String, country: String) {
        self.name = name
        self.throughfare = throughfare
        self.locality = locality
        self.administrativeArea = administrativeArea
        self.country = country
    }
    
    init(placemark: CLPlacemark) {
        name = placemark.name ?? ""
        throughfare = placemark.thoroughfare ?? ""
        locality = placemark.locality ?? ""
        administrativeArea = placemark.administrativeArea ?? ""
        country = placemark.country ?? ""
    }
    
    static let unknown = Placemark(name: "Unknown", throughfare: "", locality: "", administrativeArea: "", country: "")
}


