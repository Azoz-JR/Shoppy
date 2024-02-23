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
    
    enum CodingKeys: CodingKey {
        case latitude
        case longitude
        case placemark
    }
    
    init(clLocation: CLLocationCoordinate2D) {
        self.latitude = clLocation.latitude
        self.longitude = clLocation.longitude
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.longitude, forKey: .longitude)
        try container.encodeIfPresent(self.placemark, forKey: .placemark)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.placemark = try container.decodeIfPresent(Placemark.self, forKey: .placemark)
    }
    
    var clLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
