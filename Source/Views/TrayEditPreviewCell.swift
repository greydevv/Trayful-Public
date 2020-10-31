//
//  TrayEditPreviewCell.swift
//  Trayful
//
//  Created by Greyson Murray on 5/6/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class TrayEditPreviewCell: UICollectionViewCell {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.setAttrs(alignment: .left, color: Colors.whiteGrey, fontName: Font.Montserrat.bold, fontSize: 18.0)
        label.numberOfLines = 2
        return label
    }()
    
    var defaultTitle: String? {
        didSet {
            titleLabel.text = defaultTitle
            previousTitle = defaultTitle
        }
    }
    
    var defaultColor: UIColor? {
        didSet {
            contentView.backgroundColor = defaultColor
        }
    }
    
    private var previousTitle: String?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        self.isUserInteractionEnabled = false
        contentView.addSubview(titleLabel)
        titleLabel.setAnchors(top: contentView.topAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: contentView.leftAnchor, paddingLeft: Padding.cell, right: nil, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: nil)
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.533, constant: -(Padding.cell * 2)).isActive = true
    }
    
    func setColor(color: UIColor) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            self.contentView.backgroundColor = color
        }
    }
    
    func setTitle(title: String) {
        guard title != previousTitle else { return }
        titleLabel.slideFadeReplace(durationOut: 0.5, delayOut: 0, durationIn: 0.5, delayIn: 0, newText: title)
        previousTitle = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
