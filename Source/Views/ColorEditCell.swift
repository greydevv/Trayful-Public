//
//  ColorEditCell.swift
//  Trayful
//
//  Created by Greyson Murray on 9/22/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class ColorEditCell: UICollectionViewCell {
    
    private let colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        cv.allowsMultipleSelection = false
        cv.isScrollEnabled = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    private var colorArray: [UIColor] = ThemeColors.themeUIColors
    
    var defaultColorSelection: UIColor! {
        didSet {
            guard let row = colorArray.firstIndex(of: defaultColorSelection) else { return }
            let indexPath = IndexPath(row: row, section: 0)
            colorCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }
    
    var onUpdate: ((UIColor) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(colorCollectionView)
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.setAnchors(top: contentView.topAnchor, paddingTop: 0, bottom: contentView.bottomAnchor, paddingBottom: 0, left: contentView.leftAnchor, paddingLeft: Padding.main, right: contentView.rightAnchor, paddingRight: Padding.main, centerX: nil, centerY: nil, width: nil, height: nil)
    }
    
    private func updateDefaultSelectedCell() {
        guard let row = colorArray.firstIndex(of: defaultColorSelection) else { return }
        let cell = colorCollectionView.cellForItem(at: IndexPath(row: row, section: 0))
        cell?.backgroundColor = colorArray[row]
    }
    
    private func onColorSelection(color: UIColor) {
        onUpdate?(color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ColorEditCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        let cornerRadius = ((CGFloat(self.frame.size.width)-((Padding.main * 2) + 72))/7)/2
        cell.layer.cornerRadius = cornerRadius
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = colorArray[indexPath.row].cgColor
        if defaultColorSelection == colorArray[indexPath.row] {
            cell.backgroundColor = .clear
        } else {
            cell.backgroundColor = colorArray[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (CGFloat(self.frame.size.width)-((Padding.main * 2) + 72))/7
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.backgroundColor = .clear
        FeedbackManager.doSelection()
        onColorSelection(color: colorArray[indexPath.row])
        if defaultColorSelection != colorArray[indexPath.row] {
            updateDefaultSelectedCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return false }
        return !cell.isSelected
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.backgroundColor = colorArray[indexPath.row]
    }
}
