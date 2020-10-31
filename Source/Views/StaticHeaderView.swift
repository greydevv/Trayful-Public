//
//  StaticHeaderView.swift
//  Trayful
//
//  Created by Greyson Murray on 9/6/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class StaticHeaderView: UIView {
    
    let primaryLabel: UILabel = {
        let label = UILabel()
        label.setAttrs(alignment: .left, color: ThemeManager.current.contrast, fontName: Font.Montserrat.bold, fontSize: 35.0)
        label.numberOfLines = 2
        return label
    }()
    
    let secondaryLabel: UILabel = {
        let label = UILabel()
        label.setAttrs(alignment: .left, color: ThemeManager.current.contrast, fontName: Font.Montserrat.regular, fontSize: 20.0)
        return label
    }()
    
    var primaryText: String? {
        didSet {
            primaryLabel.text = primaryText
        }
    }
    
    var secondaryText: String? {
        didSet {
            secondaryLabel.text = secondaryText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(primaryLabel)
        primaryLabel.setAnchors(top: self.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: self.leftAnchor, paddingLeft: 0, right: self.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: nil)
        
        self.addSubview(secondaryLabel)
        secondaryLabel.setAnchors(top: primaryLabel.bottomAnchor, paddingTop: 5.0, bottom: self.bottomAnchor, paddingBottom: 0, left: self.leftAnchor, paddingLeft: 0, right: self.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: nil)
    }
    
    func updateColors() {
        primaryLabel.textColor = ThemeManager.current.contrast
        secondaryLabel.textColor = ThemeManager.current.contrast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
