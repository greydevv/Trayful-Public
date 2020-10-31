//
//  OptionTextInputCell.swift
//  Trayful
//
//  Created by Greyson Murray on 9/20/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class OptionTextInputCell: OptionCell, Inputtable {
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: Font.Montserrat.semiBold, size: 16.0)
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    var defaultText: String? {
        didSet {
            textField.text = defaultText
        }
    }
    
    var placeholder: String? {
        get { return textField.placeholder }
        set { textField.attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.current.accent]) }
    }
    
    var onUpdate: ((String) -> ())?
    var inputCharacterLimit: Int?
    var blacklist: [String] = []
    var isActive: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        updateColors()
    }
    
    private func setupView() {
        contentView.addSubview(textField)
        textField.delegate = self
        textField.setAnchors(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: icon.rightAnchor, paddingLeft: Padding.intermediate, right: contentView.rightAnchor, paddingRight: 0, centerX: nil, centerY: icon.centerYAnchor, width: nil, height: nil)
    }
    
    override func updateColors() {
        super.updateColors()
        textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.current.accent])
        textField.tintColor = ThemeManager.current.contrast
        textField.textColor = ThemeManager.current.contrast
    }
    
    override func onSelection() {
        activate()
    }
    
    private func activate() {
        isActive = true
        animateView(onCompletion: nil)
        textField.isUserInteractionEnabled = true
        textField.becomeFirstResponder()
        textField.selectAll(nil)
    }
    
    private func deactivate() {
        guard isActive else { return }
        isActive = false
        textField.isUserInteractionEnabled = false
        textField.text = defaultText
        normalizeView()
    }
    
    func confirmEntry() {
        if textField.isValid(characterLimit: inputCharacterLimit ?? 50, blacklist: blacklist) {
            textField.isUserInteractionEnabled = false
            self.endEditing(true)
            if let text = textField.text {
                defaultText = text
                onUpdate?(text)
                normalizeView()
            }
        }
    }
    
    func cancelEntry()  {
        self.endEditing(true)
        deactivate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OptionTextInputCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        confirmEntry()
        return false
    }
}
