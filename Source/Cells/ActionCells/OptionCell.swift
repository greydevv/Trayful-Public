//
//  OptionCell.swift
//  Trayful
//
//  Created by Greyson Murray on 9/18/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class OptionCell: UICollectionViewCell {
    
    private let separator = UIView()
        
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 20.0
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private var separatorLeftConstraintStart: NSLayoutConstraint!
    private var separatorRightConstraintStart: NSLayoutConstraint!
    private var separatorLeftConstraintEnd: NSLayoutConstraint!
    private var separatorRightConstraintEnd: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        updateColors()
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(separator)
        separator.setAnchors(top: nil, paddingTop: 0, bottom: contentView.bottomAnchor, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: 1.0)
        separatorLeftConstraintStart = separator.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Padding.main)
        separatorRightConstraintStart = separator.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Padding.main)
        separatorLeftConstraintEnd = separator.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0)
        separatorRightConstraintEnd = separator.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0)
        separatorLeftConstraintStart.isActive = true
        separatorRightConstraintStart.isActive = true
        
        contentView.addSubview(icon)
        icon.setAnchors(top: nil, paddingTop: 0, bottom: separator.topAnchor, paddingBottom: 10.0, left: contentView.leftAnchor, paddingLeft: Padding.main, right: nil, paddingRight: 0, centerX: nil, centerY: nil, width: 40.0, height: 40.0)
    }
    
    func updateColors() {
        separator.backgroundColor = ThemeManager.current.accent
    }
    
    func setIcon(backgroundColor: UIColor, image: UIImage?, tintColor: UIColor) {
        // backgroundColor is used for tintColor due to how the image is rendrered - image is subtractive rather than additive
        if let image = image {
            icon.image = image
        }
        icon.tintColor = backgroundColor
        icon.backgroundColor = tintColor
    }
    
    func onSelection() {
        preconditionFailure("No method specified to handle selection.")
    }
    
    func animateView(onCompletion: (() -> Void)?) {
        FeedbackManager.doSelection()
        separatorLeftConstraintStart.isActive = false
        separatorLeftConstraintEnd.isActive = true
        separatorRightConstraintStart.isActive = false
        separatorRightConstraintEnd.isActive = true
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }) { (complete) in
            if complete, let onCompletion = onCompletion {
                onCompletion()
            }
        }
    }
    
    func normalizeView() {
        separatorLeftConstraintEnd.isActive = false
        separatorLeftConstraintStart.isActive = true
        separatorRightConstraintEnd.isActive = false
        separatorRightConstraintStart.isActive = true
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }) { (complete) in
            if complete {
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
