//
//  UILabel_Anim.swift
//  Trayful
//
//  Created by Greyson Murray on 9/16/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

extension UILabel {
    
    func slideFadeReplace(durationOut: TimeInterval, delayOut: TimeInterval, durationIn: TimeInterval, delayIn: TimeInterval, newText: String) {
        self.alpha = 1
        self.transform = .identity
        self.isHidden = false
        UIView.animate(withDuration: durationOut, delay: delayOut, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(translationX: 50, y: 0)
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.text = newText
                self.transform = CGAffineTransform(translationX: -50, y: 0)
                UIView.animate(withDuration: durationIn, delay: delayIn, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.transform = .identity
                    self.alpha = 1
                })
            }
        }
    }
    
    func fadeReplace(durationOut: TimeInterval, delayOut: TimeInterval, durationIn: TimeInterval, delayIn: TimeInterval, newText: String) {
        self.alpha = 1
        UIView.animate(withDuration: durationOut, delay: delayOut, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.text = newText
                UIView.animate(withDuration: durationOut, delay: delayOut, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.alpha = 1
                })
            }
        }
    }
    
    func slideFadeIn(duration: TimeInterval, delay: TimeInterval) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: -50, y: 0)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.alpha = 1
            self.transform = .identity
        })
    }
    
    func slideFadeInFromBottom(duration: TimeInterval, delay: TimeInterval) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: 50)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.alpha = 1
            self.transform = .identity
        })
    }
    
}
