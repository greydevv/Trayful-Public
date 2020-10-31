//
//  UILabel_Ext.swift
//  Trayful
//
//  Created by Greyson Murray on 9/9/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setAttrs(alignment: NSTextAlignment, color: UIColor?, fontName: String, fontSize: CGFloat) {
        textAlignment = alignment
        textColor = color
        font = UIFont(name: fontName, size: fontSize)
    }
    
    func addCharacterSpacing(value: CGFloat) {
        guard let text = self.text else { return }
        attributedText = NSAttributedString(string: text, attributes:[NSAttributedString.Key.kern: value])
    }
    
    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight)) - 1
    }
    
}
