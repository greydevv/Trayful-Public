//
//  ItemCell.swift
//  Trayful
//
//  Created by Greyson Murray on 9/28/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//
import UIKit

class ItemCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setAttrs(alignment: .left, color: ThemeManager.current.contrast, fontName: Font.Montserrat.medium, fontSize: 18.0)
        return label
    }()
    
    private let statusView = UIView()
    
    private var isComplete: Bool = false
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var onSwipe: (()->())?
    
    private var statusIncompleteRightConstraint: NSLayoutConstraint!
    private var statusCompleteRightConstraint: NSLayoutConstraint!
    private var statusDefaultLeftConstraint: NSLayoutConstraint!
    private var statusSwipeLeftConstraint: NSLayoutConstraint!
    
    private var titleRightConstraint: NSLayoutConstraint!
    
    private var completeGesture: UISwipeGestureRecognizer!

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        updateColors()
        setupGestures()
    }
    
    private func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = .none
        contentView.addSubview(titleLabel)
        titleLabel.setAnchors(top: contentView.topAnchor, paddingTop: 0, bottom: contentView.bottomAnchor, paddingBottom: 0, left: contentView.leftAnchor, paddingLeft: 30.0 + Padding.main, right: nil, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: nil)
        
        contentView.addSubview(statusView)
        statusView.setAnchors(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: 2.0)
        statusView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 1.0).isActive = true
        
        statusView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 1).isActive = true
        
        statusDefaultLeftConstraint = statusView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Padding.main)
        statusDefaultLeftConstraint.isActive = true
        statusSwipeLeftConstraint = statusView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor)
        
        statusCompleteRightConstraint = statusView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor)
        statusIncompleteRightConstraint = statusView.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -10.0)
        
        titleRightConstraint = titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Padding.main)
    }
    
    private func updateColors() {
        contentView.backgroundColor = ThemeManager.current.prominent
        titleLabel.textColor = ThemeManager.current.contrast
        statusView.backgroundColor = ThemeManager.current.contrast
    }
    
    private func setupGestures() {
        completeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleCompleteGesture(sender:)))
        self.addGestureRecognizer(completeGesture)
    }
    
    @objc private func handleCompleteGesture(sender: UISwipeGestureRecognizer) {
        onSwipe?()
        changeCompletion()
    }
    
    private func changeCompletion() {
        isComplete = !isComplete
        updateStatusConstraints(forCompletion: isComplete, withAnimation: true)
        self.completeGesture.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.3) {
            self.completeGesture.isEnabled = true
        }
    }
    
    private func updateStatusConstraints(forCompletion complete: Bool, withAnimation animate: Bool) {
        if complete {
            statusIncompleteRightConstraint.isActive = false
            statusCompleteRightConstraint.isActive = true
        } else {
            if animate {
                repositionStatusView()
                return
            } else {
                statusCompleteRightConstraint.isActive = false
                statusIncompleteRightConstraint.isActive = true
            }
        }
        guard animate else { contentView.layoutIfNeeded(); return }
        animateLayout()
    }
    
    private func repositionStatusView() {
        statusDefaultLeftConstraint.isActive = false
        statusSwipeLeftConstraint.isActive = true
        animateLayout {
            self.statusSwipeLeftConstraint.isActive = false
            self.statusDefaultLeftConstraint.isActive = true
            self.statusCompleteRightConstraint.isActive = false
            self.statusIncompleteRightConstraint.isActive = true
            self.statusView.fadeIn(duration: 0.5, delay: 0)
        }
    }
    
    private func animateLayout(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            self.contentView.layoutIfNeeded()
        }) { (complete) in
            if complete {
                completion?()
            }
        }
    }
    
    func adjustForMaxWidth(width: CGFloat) {
        let didExceedWidth = (titleLabel.intrinsicContentSize.width > width)
        titleRightConstraint.isActive = didExceedWidth
    }
    
    func setInitialCompletion(complete: Bool) {
        self.isComplete = complete
        updateStatusConstraints(forCompletion: isComplete, withAnimation: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
