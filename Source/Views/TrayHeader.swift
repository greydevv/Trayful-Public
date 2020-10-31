//
//  TrayHeader.swift
//  Trayful
//
//  Created by Greyson Murray on 9/13/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class TrayHeader: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setAttrs(alignment: .left, color: Colors.whiteGrey, fontName: Font.Montserrat.bold, fontSize: 18.0)
        label.numberOfLines = 2
        return label
    }()
    
    private let itemsLabel: UILabel = {
        let label = UILabel()
        label.setAttrs(alignment: .left, color: Colors.whiteGrey, fontName: Font.Montserrat.semiBold, fontSize: 16.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(itemsLabel)
        itemsLabel.setAnchors(top: nil, paddingTop: 0, bottom: self.bottomAnchor, paddingBottom: Padding.cell/1.5, left: self.leftAnchor, paddingLeft: Padding.cell/1.5, right: self.rightAnchor, paddingRight: Padding.cell/1.5, centerX: nil, centerY: nil, width: nil, height: nil)
        
        self.addSubview(titleLabel)
        titleLabel.setAnchors(top: self.topAnchor, paddingTop: Padding.cell, bottom: nil, paddingBottom: 0, left: self.leftAnchor, paddingLeft: Padding.cell/1.5, right: self.rightAnchor, paddingRight: Padding.cell/1.5, centerX: nil, centerY: nil, width: nil, height: nil)
    }
    
    func configureView(title: String, items: String) {
        titleLabel.text = title
        itemsLabel.text = items
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
