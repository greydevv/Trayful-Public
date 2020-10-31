//
//  ProgressBar.swift
//  Trayful
//
//  Created by Greyson Murray on 9/13/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class ProgressBar: UIView {
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.setAttrs(alignment: .center, color: nil, fontName: Font.Montserrat.bold, fontSize: 20.0)
        return label
    }()
    
    private let completeImage: UIImageView = {
        let iv = UIImageView()
        iv.isHidden = true
        let image = Image.completeCheck
        iv.image = image
        iv.contentMode = .scaleAspectFit
        return iv
    }()
        
    private let progressPath = CAShapeLayer()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(progressLabel)
        progressLabel.setAnchors(top: self.topAnchor, paddingTop: 0, bottom: self.bottomAnchor, paddingBottom: 0, left: self.leftAnchor, paddingLeft: 0, right: self.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: nil)
        self.addSubview(completeImage)
        completeImage.setAnchors(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, centerX: self.centerXAnchor, centerY: self.centerYAnchor, width: 36.0, height: 24.0)
    }
    
    func setData(progress: Float, color: UIColor) {
        progressLabel.textColor = color
        completeImage.tintColor = color
        progressLabel.text = DataConverter.formatPercentage(percentage: progress)
        progressPath.strokeColor = color.cgColor
        setProgess(progress: progress)
    }
    
    override func layoutSubviews() {
        makePath(size: self.frame.width)
    }
    
    private func makePath(size: CGFloat) {
        let actualSize = size/2
        let middlePoint = CGPoint(x: actualSize, y: actualSize)
        let circularPath = UIBezierPath(arcCenter: middlePoint, radius: actualSize, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        progressPath.path = circularPath.cgPath
        progressPath.fillColor = UIColor.clear.cgColor
        progressPath.lineWidth = 6.0
        self.layer.addSublayer(progressPath)
    }
    
    private func setProgess(progress: Float) {
        if progress == 1 {
            setComplete()
        } else {
            setIncomplete()
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressPath.strokeEnd = CGFloat(progress)
        CATransaction.commit()
    }
    
    private func setComplete() {
        progressLabel.isHidden = true
        completeImage.isHidden = false
    }
    
    private func setIncomplete() {
        progressLabel.isHidden = false
        completeImage.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
