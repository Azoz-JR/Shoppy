//
//  ColorOption.swift
//  Shoppy
//
//  Created by Azoz Salah on 24/02/2024.
//

import UIKit

enum ColorOption: String, Codable {
    case blue
    case black
    case white
    case red
    case gray
    case yellow
    case beige
    case lightBrown = "light_brown"
    case burgandy
    
    var color: UIColor {
        switch self {
        case .blue:
            UIColor.blue
        case .black:
            UIColor.black
        case .white:
            UIColor.white
        case .red:
            UIColor.systemRed
        case .gray:
            UIColor.systemGray
        case .yellow:
            UIColor.systemYellow
        case .beige:
            UIColor.beige
        case .lightBrown:
            UIColor.lightBrown
        case .burgandy:
            UIColor.burgundy
        }
    }
}
