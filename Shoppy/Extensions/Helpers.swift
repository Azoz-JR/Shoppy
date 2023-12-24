//
//  Helper.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import UIKit

extension UIViewController {
    func show(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        showDetailViewController(alert, sender: self)
    }
    
    func showAddedSuccessfulyAlert() {
        let alert = UIAlertController(title: "Success", message: "Product added to cart successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    func select(product: ItemViewModel, productsViewModel: ProductsViewModel) {
        let vc = ProductViewController(product: product, productsViewModel: productsViewModel)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

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


extension DispatchQueue {
    static func mainAsyncIfNeeded(execute work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            main.async(execute: work)
        }
    }
}
