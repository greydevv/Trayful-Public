//
//  UITextField_Anim.swift
//  Trayful
//
//  Created by Greyson Murray on 9/16/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

extension UITextField {
    
    func slideFadeInFromBottomBecomeFirstResponder(duration: TimeInterval, delay: TimeInterval) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: 50)
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.transform = .identity
            self.alpha = 1
        }) { (complete) in
            if complete {
                self.becomeFirstResponder()
            }
        }
    }
    
    func errorShake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.08
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 10.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
    
}
