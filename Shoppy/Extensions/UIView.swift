//
//  UIView.swift
//  Shoppy
//
//  Created by Azoz Salah on 28/12/2023.
//

import UIKit

extension UIView {
    func applyShadow(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    func roundedCorners(corners: UIRectCorner, cornerRadius: CGFloat) {
        let roundedPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundedPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func round( _ radius: CGFloat = 10) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}
