//
//  InputViewController.swift
//  Trayful
//
//  Created by Greyson Murray on 9/10/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {
    
    private var addButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 33.0
        btn.adjustsImageWhenHighlighted = false
        btn.tintColor = Colors.whiteGrey
        btn.setImage(Image.plus, for: .normal)
        btn.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    var inputCharacterLimit: Int?
    
    var headerView = HeaderView()
    
    var actionView = ActionView()
    private var actionViewBottomConstraint = NSLayoutConstraint()
    
    private var dismissKeyboardTap = UITapGestureRecognizer()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCallbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        updateColors()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if headerView.isActive {
            headerView.cancelEntry()
        }
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - Interface
    
    private func setupView() {
        view.addSubview(headerView)
        headerView.setAnchors(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30.0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: Padding.main, right: view.rightAnchor, paddingRight: Padding.main, centerX: nil, centerY: nil, width: nil, height: nil)
        
        view.addSubview(actionView)
        actionView.isHidden = true
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionViewBottomConstraint = actionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        actionViewBottomConstraint.isActive = true
        actionView.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        actionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        actionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(addButton)
        view.bringSubviewToFront(addButton)
        addButton.setAnchors(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: Padding.main, left: nil, paddingLeft: 0, right: view.rightAnchor, paddingRight: Padding.main, centerX: nil, centerY: nil, width: 66.0, height: 66.0)
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        let backImage = Image.backArrow?.withRenderingMode(.alwaysTemplate).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -Padding.intermediate, bottom: 0, right: 0))
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let settingsImage = Image.settings?.withRenderingMode(.alwaysTemplate)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingsImage, style: .done, target: self, action: #selector(self.settingsButtonClicked))
        self.navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Padding.intermediate)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func updateColors() {
        view.backgroundColor = ThemeManager.current.prominent
        headerView.updateColors()
        actionView.updateColors()
        addButton.backgroundColor = ThemeManager.current.signature
        addButton.setShadow(radius: 5.0, opacity: 0.5, widthOffset: 0.0, heightOffset: 5.0, color: ThemeManager.current.shadow)
        self.navigationController?.navigationBar.tintColor = ThemeManager.current.contrast
        self.navigationController?.navigationBar.barTintColor = ThemeManager.current.prominent
    }
    
    func setHeaderData(primaryText: String, secondaryText: String, activeText: String, placeholder: String) {
        headerView.primaryText = primaryText
        headerView.secondaryText = secondaryText
        headerView.activeText = activeText
        headerView.placeholder = placeholder
    }
    
    func setActionViewData(text: String) {
        actionView.text = text
    }
    
    
    // MARK: - Responders
    
    private func setupCallbacks() {
        headerView.onUpdate = { (text: String) in
            self.onHeaderUpdate(text: text)
            self.removeDismissKeyboardTap()
        }
    }
    
    func onHeaderUpdate(text: String) {
        preconditionFailure("No method specified to handle update from header.")
    }
    
    @objc private func addButtonClicked() {
        headerView.activate()
        addButton.isUserInteractionEnabled = false
        addButton.slideFadeOut(duration: 0.5, delay: 0)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            self.dismissKeyboardTap.addTarget(self, action: #selector(self.dismissKeyboard))
            self.view.addGestureRecognizer(self.dismissKeyboardTap)
        })
    }
    
    @objc private func settingsButtonClicked() {
        let settingsController = SettingsController()
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
    
    
    // MARK: - Keyboard
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        removeDismissKeyboardTap()
        headerView.cancelEntry()
    }
    
    private func removeDismissKeyboardTap() {
        self.view.removeGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardHeight = keyboardSize.cgRectValue.height
        actionView.isHidden = false
        actionViewBottomConstraint.constant = -keyboardHeight
        actionView.onClick = { () in
            self.headerView.confirmEntry()
        }
        UIView.animate(withDuration: 0.5){
           self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        actionViewBottomConstraint.constant = actionView.frame.height
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (complete) in
            if complete {
                self.addButton.slideFadeIn(duration: 0.5, delay: 0)
                self.addButton.isUserInteractionEnabled = true
            }
        }
    }
}

