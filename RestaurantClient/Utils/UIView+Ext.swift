//
//  UIView+Ext.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 3/10/22.
//

import UIKit

extension UIView {
    
    func addFullSizeSubview(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        // Top
        NSLayoutConstraint(item: view, attribute: .topMargin, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1.0, constant: 0.0).isActive = true
        // Bottom
        NSLayoutConstraint(item: view, attribute: .bottomMargin, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0).isActive = true
        // Leading
        NSLayoutConstraint(item: view, attribute: .leadingMargin, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0).isActive = true
        // Trailing
        NSLayoutConstraint(item: view, attribute: .trailingMargin, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0).isActive = true
        
    }
}
