//
//  ActionView.swift
//  Trayful
//
//  Created by Greyson Murray on 9/7/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class ActionView: UIView {
        
    private let label: UILabel = {
        let label = UILabel()
        label.setAttrs(alignment: .center, color: Colors.whiteGrey, fontName: Font.Montserrat.semiBold, fontSize: 18.0)
        return label
    }()
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    var onClick: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(label)
        label.setAnchors(top: self.topAnchor, paddingTop: 0, bottom: self.bottomAnchor, paddingBottom: 0, left: self.leftAnchor, paddingLeft: 0, right: self.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: nil)
        createGesture()
        updateColors()
    }
    
    func updateColors() {
        self.backgroundColor = ThemeManager.current.signature
    }
    
    private func createGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleGesture))
        self.addGestureRecognizer(gesture)
    }
    
    @objc private func handleGesture() {
        onClick?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
