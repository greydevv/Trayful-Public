//
//  NewTrayCell.swift
//  Trayful
//
//  Created by Greyson Murray on 9/12/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class TrayCell: UICollectionViewCell {
    
    private let progressContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.whiteGrey
        return view
    }()
    
    private let header = TrayHeader()
    private let progressBar = ProgressBar()
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    func configureCell(tray: Tray, progress: Float) {
        parseTray(tray: tray)
        let color = DataConverter.colorFromString(color: tray.color)
        progressBar.setData(progress: progress, color: color)
        contentView.backgroundColor = color
    }
    
    private func setupCell() {
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = Colors.whiteGrey
        contentView.addSubview(progressContainer)
        progressContainer.setAnchors(top: nil, paddingTop: 0, bottom: contentView.bottomAnchor, paddingBottom: 0, left: contentView.leftAnchor, paddingLeft: 0, right: contentView.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: nil)
        progressContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true
        
        progressContainer.addSubview(progressBar)
        progressBar.setAnchors(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, centerX: progressContainer.centerXAnchor, centerY: progressContainer.centerYAnchor, width: nil , height: nil)
        progressBar.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
        progressBar.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
        
        
        contentView.addSubview(header)
        header.setAnchors(top: contentView.topAnchor, paddingTop: 0, bottom: progressContainer.topAnchor, paddingBottom: 0, left: contentView.leftAnchor, paddingLeft: 0, right: contentView.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: nil)
        
    }
    
    private func parseTray(tray: Tray) {
        let items = DataConverter.formatPlural(number: tray.items?.count ?? 0, singularString: "item")
        if let title = tray.title {
            header.configureView(title: title, items: items)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
