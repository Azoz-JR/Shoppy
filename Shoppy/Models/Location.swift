//
//  Location.swift
//  Shoppy
//
//  Created by Azoz Salah on 21/02/2024.
//

import Foundation
import MapKit

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    var placemark: Placemark?
    
    init(clLocation: CLLocationCoordinate2D) {
        self.latitude = clLocation.latitude
        self.longitude = clLocation.longitude
    }
    
    var clLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
