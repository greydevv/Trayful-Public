//
//  UIView_Ext.swift
//  Trayful
//
//  Created by Greyson Murray on 9/14/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

extension UIView {
    
    func setAnchors(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat, bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat, left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat, right: NSLayoutXAxisAnchor?, paddingRight: CGFloat, centerX: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor?, width: CGFloat?, height: CGFloat?) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo : centerY).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func setShadow(radius: CGFloat, opacity: Float, widthOffset: CGFloat, heightOffset: CGFloat, color: UIColor) {
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: widthOffset, height: heightOffset)
        layer.shadowColor = color.cgColor
    }
    
}
