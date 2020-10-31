//
//  SettingsController.swift
//  Trayful
//
//  Created by Greyson Murray on 9/18/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit
import StoreKit

class SettingsController: UIViewController {
    
    private let headerView: StaticHeaderView = {
        let view = StaticHeaderView()
        view.primaryText = "Settings"
        view.secondaryText = ""
        return view
    }()
    
    private let optionCollectionView: UICollectionView = {
        let layout = NoFadeUICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(OptionToggleCell.self, forCellWithReuseIdentifier: "optionToggleCell")
        cv.register(OptionTextInputCell.self, forCellWithReuseIdentifier: "optionTextInputCell")
        cv.register(OptionPurchaseCell.self, forCellWithReuseIdentifier: "optionPurchaseCell")
        cv.allowsMultipleSelection = false
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    private var dismissKeyboardTap = UITapGestureRecognizer()
    
    private let colorArray = [Colors.deepBlue, ThemeColors.deepPink, ThemeColors.darkBlue, ThemeColors.blueGreen]
    private let imageArray = [Image.play, Image.personal, Image.moon, Image.restore]
    
    private let defaults = UserDefaults.standard
    private let productID: String = Identifiers.productID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateColors()
        setupPaymentQueue()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let usernameCell = optionCollectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as! OptionTextInputCell
        if usernameCell.isActive {
            usernameCell.cancelEntry()
        }
    }
    
    
    // MARK: - Interface
    
    private func setupView() {
        view.addSubview(headerView)
        headerView.setAnchors(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30.0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: Padding.main, right: view.rightAnchor, paddingRight: Padding.main, centerX: nil, centerY: nil, width: nil, height: nil)
        
        view.addSubview(optionCollectionView)
        optionCollectionView.delegate = self
        optionCollectionView.dataSource = self
        optionCollectionView.setAnchors(top: headerView.bottomAnchor, paddingTop: 50.0 + Padding.main, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: nil)
    }
    
    private func updateColors() {
        view.backgroundColor = ThemeManager.current.prominent
        headerView.updateColors()
        self.navigationController?.navigationBar.tintColor = ThemeManager.current.contrast
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func setupPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
    
    private func updateInterface(withAnimation animation: Bool) {
        if animation {
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.updateColors()
            })
        } else {
            updateColors()
        }
        
        let cellsToReload = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 3, section: 0)]
        self.optionCollectionView.reloadItems(at: cellsToReload)
    }
    
    
    // MARK: - Keyboard
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        removeDismissKeyboardTap()
        let cell = optionCollectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as! OptionTextInputCell
        cell.cancelEntry()
    }
    
    private func removeDismissKeyboardTap() {
        self.view.removeGestureRecognizer(dismissKeyboardTap)
    }
    
    
    // MARK: - Settings
    
    private func purchaseRemoveAdvertisements() {
        setInteractionEnabled(enabled: false)
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("Error: User cannot make payments.")
            setInteractionEnabled(enabled: true)
        }
    }
    
    private func setInteractionEnabled(enabled: Bool) {
        self.view.window?.isUserInteractionEnabled = enabled
    }
    
    private func completePurchase() {
        defaults.set(true, forKey: productID)
    }
    
    private func restorePurchases() {
        setInteractionEnabled(enabled: false)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func endPurchaseTransaction(successful: Bool) {
        let cell = optionCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! OptionPurchaseCell
        cell.endTransaction()
        
        if successful {
            cell.doPurchaseAnimation()
        }
    }
    
    private func endRestoreTransaction(successful: Bool) {
        if successful {
            let cell = optionCollectionView.cellForItem(at: IndexPath(row: 0)) as! OptionPurchaseCell
            cell.doPurchaseAnimation()
        }
    }
    
    private func toggleDarkMode() {
        let currentDarkModeStatus = defaults.bool(forKey: "dark")
        defaults.set(!currentDarkModeStatus, forKey: "dark")
        ThemeManager.setCurrent(theme: defaults.bool(forKey: "dark") ? DarkTheme() : LightTheme())
        updateInterface(withAnimation: true)
    }
}

extension SettingsController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath == IndexPath(row: 0, section: 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionPurchaseCell", for: indexPath) as! OptionPurchaseCell
            cell.title = "Remove ads"
            cell.purchased = defaults.bool(forKey: productID)
            cell.setStatusImages(purchased: Image.purchased, notPurchased: Image.purchasePrice)
            cell.setIcon(backgroundColor: colorArray[indexPath.row], image: imageArray[indexPath.row], tintColor: Colors.whiteGrey)
            return cell
        } else if indexPath == IndexPath(row: 1, section: 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionTextInputCell", for: indexPath) as! OptionTextInputCell
            cell.placeholder = "Username"
            cell.defaultText = defaults.string(forKey: "username")
            cell.setIcon(backgroundColor: colorArray[indexPath.row], image: imageArray[indexPath.row], tintColor: Colors.whiteGrey)
            return cell
        } else if indexPath == IndexPath(row: 2, section: 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionToggleCell", for: indexPath) as! OptionToggleCell
            if defaults.bool(forKey: "dark") {
                cell.setIcon(backgroundColor: Colors.gold, image: Image.sun, tintColor: Colors.whiteGrey)
                cell.title = "Light mode"
            } else {
                cell.setIcon(backgroundColor: colorArray[indexPath.row], image: imageArray[indexPath.row], tintColor: Colors.whiteGrey)
                cell.title = "Dark mode"
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionToggleCell", for: indexPath) as! OptionToggleCell
            cell.title = "Restore purchases"
            cell.setIcon(backgroundColor: colorArray[indexPath.row], image: imageArray[indexPath.row], tintColor: Colors.whiteGrey)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 51.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath == IndexPath(row: 0, section: 0) {
            let purchased = defaults.bool(forKey: productID)
            purchased ? FeedbackManager.doError() : purchaseRemoveAdvertisements()
            
        } else if indexPath == IndexPath(row: 1, section: 0) {
            let cell = collectionView.cellForItem(at: indexPath) as! OptionTextInputCell
            self.dismissKeyboardTap.addTarget(self, action: #selector(self.dismissKeyboard))
            self.view.addGestureRecognizer(self.dismissKeyboardTap)
            cell.onUpdate = { (text: String) in
                self.defaults.setValue(text, forKey: "username")
                self.removeDismissKeyboardTap()
            }
            
        } else if indexPath == IndexPath(row: 2, section: 0) {
            toggleDarkMode()
            let cell = collectionView.cellForItem(at: indexPath) as! OptionToggleCell
            cell.updateColors()
            if defaults.bool(forKey: "dark") {
                cell.setIcon(backgroundColor: Colors.gold, image: Image.sun, tintColor: Colors.whiteGrey)
                cell.title = "Light mode"
            } else {
                cell.setIcon(backgroundColor: colorArray[indexPath.row], image: imageArray[indexPath.row], tintColor: Colors.whiteGrey)
                cell.title = "Dark mode"
            }
            
        } else if indexPath == IndexPath(row: 3, section: 0) {
            let purchased = defaults.bool(forKey: productID)
            purchased ? FeedbackManager.doError() : restorePurchases()
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! OptionCell
        cell.onSelection()
    }
}

extension SettingsController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                // user successfully purchased this item
                completePurchase()
                endPurchaseTransaction(successful: true)
                setInteractionEnabled(enabled: true)
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                // user failed to purchase this items
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Error: \(errorDescription)")
                }
                endPurchaseTransaction(successful: false)
                setInteractionEnabled(enabled: true)
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .restored {
                // user successfully restored this purchase
                completePurchase()
                endRestoreTransaction(successful: true)
                setInteractionEnabled(enabled: true)
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
}
