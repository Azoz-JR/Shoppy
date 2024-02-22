//
//  AddressValidationError.swift
//  Shoppy
//
//  Created by Azoz Salah on 22/02/2024.
//

import Foundation

enum AddressValidationError: Error, LocalizedError {
    case nameEmpty
    case phoneEmpty
    case locationEmpty
    case streetEmpty
    case buildingEmpty
    case floorEmpty
    case areaEmpty
    case landmarkEmpty
    
    var errorDescription: String {
        switch self {
        case .nameEmpty:
            return "Name field is empty."
        case .phoneEmpty:
            return "Phone field is empty."
        case .locationEmpty:
            return "Location field is empty."
        case .streetEmpty:
            return "Street field is empty."
        case .buildingEmpty:
            return "Building field is empty."
        case .floorEmpty:
            return "Floor field is empty."
        case .areaEmpty:
            return "Area field is empty."
        case .landmarkEmpty:
            return "Landmark field is empty."
        }
    }
}
