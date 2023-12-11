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
    
    func select(product: Product) {
        let vc = ProductViewController()
        vc.product = product
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
}

extension UIView {
    func roundedCorners(corners: UIRectCorner, cornerRadius: CGFloat) {
        let roundedPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundedPath.cgPath
        self.layer.mask = maskLayer
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
