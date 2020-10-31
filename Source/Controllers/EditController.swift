//
//  EditController.swift
//  Trayful
//
//  Created by Greyson Murray on 9/21/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class EditController: UIViewController {
    
    private var optionCollectionView: UICollectionView = {
        let layout = NoFadeUICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TrayEditPreviewCell.self, forCellWithReuseIdentifier: "trayEditPreviewCell")
        cv.register(ColorEditCell.self, forCellWithReuseIdentifier: "colorEditCell")
        cv.register(OptionTextInputCell.self, forCellWithReuseIdentifier: "optionTextInputCell")
        cv.register(OptionDoubleToggleCell.self, forCellWithReuseIdentifier: "optionDoubleToggleCell")
        cv.allowsMultipleSelection = false
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    private var selectedTray: Tray?
    
    private var newColor: UIColor?
    private var newTitle: String?
    var blacklist: [String] = []
    
    private var dismissKeyboardTap = UITapGestureRecognizer()
    
    var commitEdits: ((UIColor?, String?) -> ())?
    
    var onDeletion: (() -> ())?
    
    init(for tray: Tray) {
        super.init(nibName: nil, bundle: nil)
        self.selectedTray = tray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateColors()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let titleCell = optionCollectionView.cellForItem(at: IndexPath(row: 2, section: 0)) as! OptionTextInputCell
        if titleCell.isActive {
            titleCell.cancelEntry()
        }
        commitEdits?(newColor, newTitle)
    }
    
    private func setupView() {
        view.addSubview(optionCollectionView)
        optionCollectionView.dataSource = self
        optionCollectionView.delegate = self
        optionCollectionView.setAnchors(top: view.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: nil)
    }
    
    private func updateColors() {
        view.backgroundColor = ThemeManager.current.prominent
    }
    
    private func changeColor(color: UIColor) {
        newColor = color
        let cell = optionCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! TrayEditPreviewCell
        cell.setColor(color: color)
    }
    
    private func changeTitle(title: String) {
        newTitle = title
        let cell = optionCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! TrayEditPreviewCell
        cell.setTitle(title: title)
    }
    
    // MARK: - Keyboard
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        removeDismissKeyboardTap()
        let cell = optionCollectionView.cellForItem(at: IndexPath(row: 2, section: 0)) as! OptionTextInputCell
        cell.cancelEntry()
    }
    
    private func removeDismissKeyboardTap() {
        self.view.removeGestureRecognizer(dismissKeyboardTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath == IndexPath(row: 0, section: 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trayEditPreviewCell", for: indexPath) as! TrayEditPreviewCell
            cell.defaultTitle = selectedTray?.title
            cell.defaultColor = DataConverter.colorFromString(color: selectedTray?.color)
            return cell
        } else if indexPath == IndexPath(row: 1, section: 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorEditCell", for: indexPath) as! ColorEditCell
            let selectedColor = DataConverter.colorFromString(color: selectedTray?.color)
            cell.defaultColorSelection = selectedColor
            
            cell.onUpdate = { (color: UIColor) in
                self.changeColor(color: color)
            }
            
            return cell
        } else if indexPath == IndexPath(row: 2, section: 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionTextInputCell", for: indexPath) as! OptionTextInputCell
            cell.defaultText = selectedTray?.title
            cell.blacklist = blacklist
            cell.placeholder = "Title"
            cell.setIcon(backgroundColor: ThemeManager.current.prominent, image: Image.pencil, tintColor: ThemeManager.current.contrast)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionDoubleToggleCell", for: indexPath) as! OptionDoubleToggleCell
            cell.title = "Delete"
            cell.secondTitle = "Press again to confirm"
            cell.setIcon(backgroundColor: ThemeManager.current.prominent, image: Image.trash, tintColor: ThemeManager.current.contrast)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == IndexPath(row: 0, section: 0) {
            return CGSize(width: view.frame.width, height: view.frame.height * 130/812)
        }
        return CGSize(width: view.frame.width, height: 51.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let cell = collectionView.cellForItem(at: indexPath) as! OptionTextInputCell
            cell.onSelection()
            self.dismissKeyboardTap.addTarget(self, action: #selector(self.dismissKeyboard))
            self.view.addGestureRecognizer(self.dismissKeyboardTap)
            cell.onUpdate = { (text: String) in
                self.changeTitle(title: text)
                self.removeDismissKeyboardTap()
            }
            
        } else if indexPath.row == 3 {
            let cell = collectionView.cellForItem(at: indexPath) as! OptionDoubleToggleCell
            if cell.isConfirmable {
                cell.confirm()
            } else {
                cell.onSelection()
                cell.onConfirm = { () in
                    self.onDeletion?()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath != IndexPath(row: 1, section: 0)
    }
    
}
