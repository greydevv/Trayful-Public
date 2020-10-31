//
//  UIView_Anim.swift
//  Trayful
//
//  Created by Greyson Murray on 9/16/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

extension UIView {
    
    func fadeIn(duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.alpha = 1
        }) { (complete) in
            if complete {
                completion?()
            }
        }
    }
    
    func fadeOut(duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)? = nil) {
        self.alpha = 1
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.isHidden = true
                completion?()
            }
        }
    }
    
    func bounce(scaleX: CGFloat, scaleY: CGFloat) {
        self.transform = .identity
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        }) { (complete) in
            if complete {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.transform = .identity
                })
            }
        }
    }
    
    func fadeOutFadeIn(durationOut: TimeInterval, delayOut: TimeInterval, durationIn: TimeInterval, delayIn: TimeInterval, breakConstraints: [NSLayoutConstraint], addConstraints: [NSLayoutConstraint]) {
        self.alpha = 1
        UIView.animate(withDuration: durationOut, delay: delayOut, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.alpha = 0
        }) { (complete) in
            
            for constraint in breakConstraints {
                constraint.isActive = false
            }
            
            for constraint in addConstraints {
                constraint.isActive = true
            }
            
            if complete {
                UIView.animate(withDuration: durationIn, delay: delayIn, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.alpha = 1
                })
            }
        }
    }
    
}
