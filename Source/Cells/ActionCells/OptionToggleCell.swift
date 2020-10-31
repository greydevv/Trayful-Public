//
//  OptionToggleCell.swift
//  Trayful
//
//  Created by Greyson Murray on 9/18/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class OptionToggleCell: OptionCell {
    
    internal let label: UILabel = {
        let label = UILabel()
        label.setAttrs(alignment: .left, color: ThemeManager.current.contrast, fontName: Font.Montserrat.semiBold, fontSize: 16.0)
        return label
    }()
    
    var title: String? {
        didSet {
            label.text = title
        }
    }
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        updateColors()
    }
    
    private func setupView() {
        contentView.addSubview(label)
        label.setAnchors(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: icon.rightAnchor, paddingLeft: Padding.intermediate, right: contentView.rightAnchor, paddingRight: 0, centerX: nil, centerY: icon.centerYAnchor, width: nil, height: nil)
    }
    
    override func updateColors() {
        super.updateColors()
        label.textColor = ThemeManager.current.contrast
    }
    
    override func onSelection() {
        self.isUserInteractionEnabled = false
        animateView(onCompletion: normalizeView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
