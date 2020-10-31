//
//  EmptyContentLabel.swift
//  Trayful
//
//  Created by Greyson Murray on 9/16/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class EmptyContentLabel: UILabel {
    
    private var attributedRange: NSRange?
    
    func setData(text: String, range: NSRange) {
        self.text = text
        self.setAttrs(alignment: .center, color: ThemeManager.current.accent, fontName: Font.Montserrat.medium, fontSize: 16.0)
        self.numberOfLines = 2
        self.attributedRange = range
        setAttributedString()
    }
    
    private func setAttributedString() {
        guard let message = self.text, let range = attributedRange else { return }
        let attrStr = NSMutableAttributedString.init(string: message)
        attrStr.setAttributes([NSAttributedString.Key.font: UIFont(name: Font.Montserrat.semiBoldItalic, size: 16.0)!, NSAttributedString.Key.foregroundColor: ThemeManager.current.signature],range: range)
        self.attributedText = attrStr
    }
    
    func updateColors() {
        self.textColor = ThemeManager.current.accent
        setAttributedString()
    }
}
