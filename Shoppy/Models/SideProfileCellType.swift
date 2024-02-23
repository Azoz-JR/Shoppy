//
//  SideProfile.swift
//  Shoppy
//
//  Created by Azoz Salah on 22/01/2024.
//

import UIKit


enum SideProfileCellType: CaseIterable {
    case wishList
    case orders
    case lists
    
    var title: String {
        switch self {
        case .wishList:
            "Wish list"
        case .orders:
            "Orders"
        case .lists:
            "Lists"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .wishList:
            UIImage(systemName: "heart.fill")
        case .orders:
            UIImage(systemName: "dollarsign.square.fill")
        case .lists:
            UIImage(systemName: "list.bullet.clipboard.fill")
        }
    }
}
