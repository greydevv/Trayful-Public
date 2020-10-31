//
//  OptionPurchaseCell.swift
//  Trayful
//
//  Created by Greyson Murray on 9/21/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class OptionPurchaseCell: OptionToggleCell {
    
    var purchased: Bool = false
    
    private var purchasedImage: UIImage?
    private var purchasePriceImage: UIImage?
    
    private let purchasedIndicator: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .right
        iv.backgroundColor = Colors.whiteGrey
        iv.layer.cornerRadius = 11.0
        iv.tintColor = Colors.deepBlue
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(purchasedIndicator)
        purchasedIndicator.setAnchors(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: contentView.rightAnchor, paddingRight: Padding.main, centerX: nil, centerY: icon.centerYAnchor, width: nil, height: 22.0)
    }
    
    override func onSelection() {
        self.isUserInteractionEnabled = false
        animateView(onCompletion: purchased ? normalizeView : nil)
    }
    
    func setStatusImages(purchased: UIImage?, notPurchased: UIImage?) {
        self.purchasedImage = purchased
        self.purchasePriceImage = notPurchased
        purchasedIndicator.image = self.purchased ? purchased : notPurchased
    }
    
    func doPurchaseAnimation() {
        purchasedIndicator.fadeImageChange(newImage: purchasedImage)
    }
    
    func endTransaction() {
        normalizeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
