//
//  OptionDoubleToggleCell.swift
//  Trayful
//
//  Created by Greyson Murray on 9/23/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class OptionDoubleToggleCell: OptionToggleCell {
    
    var secondTitle: String?
    
    var isConfirmable: Bool = false
    
    var onConfirm: (() -> ())?
    
    override func onSelection() {
        animateView(onCompletion: nil)
        if let secondTitle = secondTitle {
            label.slideFadeReplace(durationOut: 0.5, delayOut: 0, durationIn: 0.5, delayIn: 0, newText: secondTitle)
        }
        isConfirmable = true
        setupAutoCancel()
    }
    
    private func setupAutoCancel() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.cancel()
        }
    }
    
    override func normalizeView() {
        super.normalizeView()
        self.isConfirmable = false
        if let title = title {
            label.slideFadeReplace(durationOut: 0.5, delayOut: 0, durationIn: 0.5, delayIn: 0, newText: title)
        }
    }
    
    func confirm() {
        label.layer.removeAllAnimations()
        normalizeView()
        onConfirm?()
    }
    
    func cancel() {
        guard isConfirmable else { return }
        normalizeView()
        isConfirmable = false
    }
}
