//
//  ItemController.swift
//  Trayful
//
//  Created by Greyson Murray on 9/12/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class ItemController: InputViewController, UIGestureRecognizerDelegate {
    
    private let itemTableView: UITableView = {
        let tv = UITableView()
        tv.register(ItemCell.self, forCellReuseIdentifier: "itemCell")
        tv.backgroundColor = .clear
        tv.separatorColor = .clear
        tv.showsVerticalScrollIndicator = false
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
        tv.contentInset = .zero
        tv.allowsSelection = false
        tv.allowsMultipleSelection = false
        tv.bounces = true
        return tv
    }()
    
    private let emptyContentImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private var selectedTray: Tray!
    private var itemArray = [Item]()
    private var canInteract: Bool = true
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var interstitial: GADInterstitial!
    
    // MARK: - Initialization
    
    init(with tray: Tray) {
        super.init(nibName: nil, bundle: nil)
        self.selectedTray = tray
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ThemeManager.current.setSignature(color: DataConverter.colorFromString(color: selectedTray.color))
        super.viewWillAppear(animated)
        loadData()
        setupBaseViews()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let appSignature = ThemeManager.appSignature else { return }
        ThemeManager.current.setSignature(color: appSignature)
        saveItems()
    }
    
    
    // MARK: - Interface
    
    private func setupBaseViews() {
        inputCharacterLimit = 150
        setActionViewData(text: "Create")
        if let title = selectedTray.title {
            let secondaryText = DataConverter.formatPlural(number: itemArray.count, singularString: "item")
            setHeaderData(primaryText: title, secondaryText: secondaryText, activeText: "New Item", placeholder: "Title")
        }
    }
    
    private func setupView() {
        view.addSubview(emptyContentImage)
        view.sendSubviewToBack(emptyContentImage)
        emptyContentImage.setAnchors(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: nil, height: nil)
        emptyContentImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55).isActive = true
        
        view.addSubview(itemTableView)
        view.sendSubviewToBack(itemTableView)
        itemTableView.delegate = self
        itemTableView.dataSource = self
        itemTableView.setAnchors(top: headerView.bottomAnchor, paddingTop: 50.0 + Padding.main, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: nil )
    }
    
    override func updateColors() {
        super.updateColors()
        let defaults = UserDefaults.standard
        emptyContentImage.image  = defaults.bool(forKey: "dark") ? Image.emptyIndicationDark : Image.emptyIndicationLight
    }
    
    private func updateContentForDestructiveAction() {
        headerView.secondaryLabel.fadeReplace(durationOut: 0.5, delayOut: 0, durationIn: 0.5, delayIn: 0.5, newText: DataConverter.formatPlural(number: itemArray.count, singularString: "item"))
        guard itemArray.count == 0 else { return }
        itemTableView.fadeOut(duration: 1, delay: 0)
        emptyContentImage.fadeIn(duration: 1, delay: 1)
    }
    
    private func updateContentForAdditiveAction() {
        headerView.secondaryText = DataConverter.formatPlural(number: itemArray.count, singularString: "item")
        guard itemArray.count == 1 else { return }
        emptyContentImage.fadeOut(duration: 1, delay: 0)
        itemTableView.fadeIn(duration: 1, delay: 1)
    }
    
    private func updateContentInitialVisibility() {
        let isContentVisible = (itemArray.count == 0)
        itemTableView.isHidden = isContentVisible
        emptyContentImage.isHidden = !isContentVisible
    }
    
    
    // MARK: - Advertisements
    
    private func setupAd() {
        interstitial = createAndLoadInterstitial()
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
    }
    
    private func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: Identifiers.adUnitID)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    private func tryAd() {
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: Identifiers.productID) && (itemArray.count % 3 == 0) else { return }
        showAd()
    }
    
    private func showAd() {
        if interstitial.isReady {
          interstitial.present(fromRootViewController: self)
        } else {
          print("Cannot present interstitial. It is not ready.")
        }
    }
    
    
    // MARK: - Responders
    
    override func onHeaderUpdate(text: String) {
        addNewItem(title: text)
    }
    
    
    // MARK: - Data Manipulation
    
    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
    }
    
    private func loadData() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        if let filter = selectedTray.title {
            request.predicate = NSPredicate(format: "parentTray.title == %@", filter)
        }
        do {
            itemArray = try context.fetch(request)
            itemTableView.reloadData()
            updateContentInitialVisibility()
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    private func addNewItem(title: String) {
        let newItem = Item(context: context)
        newItem.title = title.trimmingCharacters(in: .whitespaces)
        newItem.complete = false
        newItem.parentTray = selectedTray
        itemArray.append(newItem)
        itemTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        updateContentForAdditiveAction()
        tryAd()
        saveItems()
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        let reversedRow = indexPath.invertRow(arrayLength: itemArray.count)
        context.delete(itemArray[reversedRow])
        itemArray.remove(at: reversedRow)
        updateContentForDestructiveAction()
        saveItems()
    }
    
    private func toggleCompletion(forItemAt indexPath: IndexPath) {
        itemArray[indexPath.row].complete = !itemArray[indexPath.row].complete
        saveItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ItemController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemData: [Item] = itemArray.reversed()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        cell.title = itemData[indexPath.row].title
        cell.setInitialCompletion(complete: itemData[indexPath.row].complete)
        
        let maxWidth = (view.frame.width - ((Padding.main * 2) + 26))
        cell.adjustForMaxWidth(width: maxWidth)

        cell.onSwipe = { () in
            let reversedRow = indexPath.invertRow(arrayLength: itemData.count)
            self.toggleCompletion(forItemAt: IndexPath(row: reversedRow))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard canInteract else { return nil }
        let delete = UIContextualAction(style: .destructive, title: "delete") {  (contextualAction, view, boolValue) in
            self.deleteItem(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
        delete.backgroundColor = ThemeManager.current.signature
        delete.image = Image.trashIcon?.withTintColor(Colors.whiteGrey)
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
    
}

extension ItemController: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
}
