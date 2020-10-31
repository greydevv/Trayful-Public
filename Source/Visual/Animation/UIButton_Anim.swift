//
//  UIButton_Anim.swift
//  Trayful
//
//  Created by Greyson Murray on 9/16/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

extension UIButton {
    
    func slideFadeIn(duration: TimeInterval, delay: TimeInterval) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: self.frame.width, y: 0)
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.transform = .identity
            self.alpha = 1
        })
    }
    
    func slideFadeOut(duration: TimeInterval, delay: TimeInterval) {
        self.alpha = 1
        self.transform = .identity
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(translationX: self.frame.width, y: 0)
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.isHidden = true
            }
        }
    }
    
}
