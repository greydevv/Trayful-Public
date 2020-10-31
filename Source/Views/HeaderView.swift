//
//  HeaderView.swift
//  Trayful
//
//  Created by Greyson Murray on 9/6/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class HeaderView: StaticHeaderView, Inputtable {
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: Font.Montserrat.regular, size: 20.0)
        return textField
    }()
    
    var activeText: String?
    
    var isActive: Bool = false
    
    var blacklist: [String] = []
    var onUpdate: ((String) -> ())?
    var inputCharacterLimit: Int?
    
    var placeholder: String? {
        get { return textField.placeholder }
        set { textField.attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.current.accent]) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(textField)
        textField.isHidden = true
        textField.delegate = self
        textField.setAnchors(top: secondaryLabel.topAnchor, paddingTop: 0, bottom: secondaryLabel.bottomAnchor, paddingBottom: 0, left: self.leftAnchor, paddingLeft: 0, right: self.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: nil)
    }
    
    func activate() {
        isActive = true
        primaryLabel.slideFadeReplace(durationOut: 0.5, delayOut: 0, durationIn: 0.5, delayIn: 0, newText: activeText ?? "")
        secondaryLabel.fadeOut(duration: 0.5, delay: 0)
        textField.fadeIn(duration: 0.5, delay: 0.5)
        textField.clear()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            self.textField.becomeFirstResponder()
        })
    }
    
    func deactivate() {
        guard isActive else { return }
        isActive = false
        primaryLabel.slideFadeReplace(durationOut: 0.5, delayOut: 0, durationIn: 0.5, delayIn: 0, newText: primaryText ?? "")
        textField.fadeOut(duration: 0.5, delay: 0)
        secondaryLabel.fadeIn(duration: 0.5, delay: 0.5)
    }
    
    func confirmEntry() {
        if textField.isValid(characterLimit: inputCharacterLimit ?? 50, blacklist: blacklist) {
            self.endEditing(true)
            if let text = textField.text {
                onUpdate?(text)
                deactivate()
            }
        }
    }
    
    func cancelEntry() {
        self.endEditing(true)
        deactivate()
    }
    
    override func updateColors() {
        primaryLabel.textColor = ThemeManager.current.contrast
        secondaryLabel.textColor = ThemeManager.current.contrast
        textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.current.accent])
        textField.tintColor = ThemeManager.current.contrast
        textField.textColor = ThemeManager.current.contrast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        confirmEntry()
        return false
    }
}

extension HeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        return cell
    }
    
    
}
