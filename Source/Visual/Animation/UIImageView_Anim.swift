//
//  UIImageView_Anim.swift
//  Trayful
//
//  Created by Greyson Murray on 9/16/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func slideFadeIn(duration: TimeInterval, delay: TimeInterval) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: -50, y: 0)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.alpha = 1
            self.transform = .identity
        })
    }
    
    func fadeImageChange(newImage: UIImage?) {
        guard let newImage = newImage else { return }
        self.alpha = 1
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.image = newImage
                UIView.animate(withDuration: 0.5) {
                    self.alpha = 1
                }
            }
        }
    }
}
