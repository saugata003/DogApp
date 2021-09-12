//
//  UIView+Addirtions.swift
//  DogApp
//
//  Created by Saugata on 11/09/21.
//

import UIKit
extension UIView {
    @objc func roundCorners(_ cornerRadius: CGFloat, _ borderWidth: CGFloat, _ borderColor: UIColor) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
    }
}
