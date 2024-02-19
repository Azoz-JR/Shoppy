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
    
    func selectPaymentMethod() {
        let radius = min(bounds.width, bounds.height) / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        round(radius)
        
        // Create the outer blue half circle layer
        let outerHalfLayer = CAShapeLayer()
        let outerHalfPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        outerHalfLayer.path = outerHalfPath.cgPath
        outerHalfLayer.strokeColor = UIColor.clear.cgColor
        outerHalfLayer.fillColor = UIColor.tintColor.cgColor
        
        // Create the inner white half circle layer
        let innerHalfLayer = CAShapeLayer()
        let innerHalfPath = UIBezierPath(arcCenter: center, radius: radius / 3, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        innerHalfLayer.path = innerHalfPath.cgPath
        innerHalfLayer.strokeColor = UIColor.clear.cgColor
        innerHalfLayer.fillColor = UIColor.white.cgColor
        
        // Add the layers to the view's layer
        layer.addSublayer(outerHalfLayer)
        layer.addSublayer(innerHalfLayer)
    }
    
    func deselectPaymentMethod() {
        let radius = min(bounds.width, bounds.height) / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        round(radius)
        
        // Create the outer blue half circle layer
        let outerHalfLayer = CAShapeLayer()
        let outerHalfPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        outerHalfLayer.path = outerHalfPath.cgPath
        outerHalfLayer.strokeColor = UIColor.lightGray.cgColor
        outerHalfLayer.fillColor = UIColor.clear.cgColor
        
        // Add the layers to the view's layer
        layer.addSublayer(outerHalfLayer)
    }
}
