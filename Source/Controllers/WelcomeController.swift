//
//  WelcomeController.swift
//  Trayful
//
//  Created by Greyson Murray on 12/19/19.
//  Copyright © 2019 Greyson Murray. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController {
    
    private let trayfulLabel: UIImageView = {
        let imageView = UIImageView()
        let image = Image.logoLight
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let primaryLabel: UILabel = {
        let label = UILabel()
        label.setAttrs(alignment: .left, color: Colors.whiteGrey, fontName: Font.Montserrat.bold, fontSize: 35.0)
        label.text = "Hi there"
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.setAttrs(alignment: .left, color: Colors.whiteGrey, fontName: Font.Montserrat.regular, fontSize: 20.0)
        label.text = "Welcome to Trayful"
        return label
    }()
    
    private let questionLabelFirst: UILabel = {
        let label = UILabel()
        label.setAttrs(alignment: .left, color: Colors.whiteGrey, fontName: Font.Montserrat.bold, fontSize: 18.0)
        label.text = "Before we get started,"
        return label
    }()
    
    private let questionLabelSecond: UILabel = {
        let label = UILabel()
        label.setAttrs(alignment: .left, color: Colors.whiteGrey, fontName: Font.Montserrat.italic, fontSize: 18.0)
        label.text = "what's your name?"
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 20
        textField.layer.borderColor = Colors.whiteGrey.cgColor
        textField.tintColor = Colors.whiteGrey
        textField.font = UIFont(name: Font.Montserrat.medium, size: 20)
        textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: Colors.deepLightBlue])
        textField.textColor = Colors.whiteGrey
        textField.returnKeyType = .continue
        return textField
    }()
    
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        animateViewIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupView() {
        view.backgroundColor = Colors.deepBlue

        view.addSubview(trayfulLabel)
        trayfulLabel.setAnchors(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: Padding.main, right: nil, paddingRight: 0, centerX: nil, centerY: nil, width: 67, height: 36)
        
        view.addSubview(primaryLabel)
        primaryLabel.setAnchors(top: trayfulLabel.bottomAnchor, paddingTop: 50.0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: Padding.main, right: view.rightAnchor, paddingRight: Padding.main, centerX: nil, centerY: nil, width: nil, height: nil)
        
        view.addSubview(secondaryLabel)
        secondaryLabel.setAnchors(top: primaryLabel.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: Padding.main, right: view.rightAnchor, paddingRight: Padding.main, centerX: nil, centerY: nil, width: nil, height: nil)
        
        view.addSubview(questionLabelFirst)
        questionLabelFirst.setAnchors(top: secondaryLabel.bottomAnchor, paddingTop: 60.0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: Padding.main, right: view.rightAnchor, paddingRight: Padding.main, centerX: nil, centerY: nil, width: nil, height: nil)
        
        view.addSubview(questionLabelSecond)
        questionLabelSecond.setAnchors(top: questionLabelFirst.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: Padding.main, right: view.rightAnchor, paddingRight: Padding.main, centerX: nil, centerY: nil, width: nil, height: nil)
        
        view.addSubview(nameTextField)
        nameTextField.delegate = self
        nameTextField.setAnchors(top: questionLabelSecond.bottomAnchor, paddingTop: Padding.main, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: Padding.main, right: view.rightAnchor, paddingRight: Padding.main, centerX: nil, centerY: nil, width: nil, height: nil)
        
    }
    
    
    // MARK: - Confirming Entry
    
    private func confirmEntry() {
        if nameTextField.isValid(characterLimit: 50, blacklist: []) {
            view.endEditing(true)
            if let text = nameTextField.text {
                defaults.set(text, forKey: "username")
                nextView()
            }
        }
    }
    
    
    // MARK: - Animations and State Change
    
    private func animateViewIn() {
        trayfulLabel.slideFadeIn(duration: 0.8, delay: 0.75)
        primaryLabel.slideFadeIn(duration: 0.8, delay: 0.75)
        secondaryLabel.slideFadeIn(duration: 0.8, delay: 0.75)
        questionLabelFirst.fadeIn(duration: 1, delay: 3)
        questionLabelSecond.slideFadeInFromBottom(duration: 1, delay: 3.5)
        nameTextField.slideFadeInFromBottomBecomeFirstResponder(duration: 1, delay: 4)
    }
    
    private func nextView() {
        primaryLabel.slideFadeReplace(durationOut: 1, delayOut: 0, durationIn: 1, delayIn: 0, newText: "Hi, \(defaults.string(forKey: "username")!)")
        secondaryLabel.slideFadeReplace(durationOut: 1, delayOut: 0, durationIn: 1, delayIn: 0, newText: "Welcome to Trayful")
        questionLabelFirst.fadeOut(duration: 1, delay: 0)
        questionLabelSecond.fadeOut(duration: 1, delay: 0)
        nameTextField.fadeOut(duration: 1, delay: 0)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
            _ = self.navigationController?.popViewController(animated: true)
            self.defaults.set(true, forKey: "firstLaunch")
        })
    }
    
}

extension WelcomeController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        confirmEntry()
        return false
    }
}
