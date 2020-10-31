//
//  TrayController.swift
//  Trayful
//
//  Created by Greyson Murray on 9/10/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class TrayController: InputViewController {
    
    private let trayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TrayCell.self, forCellWithReuseIdentifier: "trayCell")
        cv.backgroundColor = .clear
        cv.allowsMultipleSelection = false
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = true
        cv.layer.masksToBounds = false
        cv.dragInteractionEnabled = true
        return cv
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Trays"
        label.setAttrs(alignment: .left, color: nil, fontName: Font.Montserrat.medium, fontSize: 16.0)
        return label
    }()
    
    private let emptyContentLabel = EmptyContentLabel()
    
    private var trayArray = [Tray]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var interstitial: GADInterstitial!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !tryWelcome() else { return }
        loadTrays()
        loadBlacklist()
        setupBaseViews()
    }
    
    private func tryWelcome() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "firstLaunch") {
            // not first launch
            return false
        } else {
            // first launch
            let welcomeController = WelcomeController()
            self.navigationController?.pushViewController(welcomeController, animated: false)
            return true
        }
    }
    
    
    // MARK: - Interface
    
    private func setupBaseViews() {
        setActionViewData(text: "Create")
        if let date = Date().getDate() {
            let defaults = UserDefaults.standard
            let username = defaults.string(forKey: "username") ?? ""
            setHeaderData(primaryText: date, secondaryText: "Hi, \(username)", activeText: "New Tray", placeholder: "Title")
        }        
        emptyContentLabel.setData(text: "Your desk is empty!\nAdd a Tray to get started.", range: NSMakeRange(12, 7))
    }
    
    private func setupView() {
        inputCharacterLimit = 50
        view.addSubview(headerLabel)
        headerLabel.setAnchors(top: headerView.bottomAnchor, paddingTop: 80.0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: Padding.main, right: view.rightAnchor, paddingRight: Padding.main, centerX: nil, centerY: nil, width: nil, height: nil)
        
        view.addSubview(emptyContentLabel)
        view.sendSubviewToBack(emptyContentLabel)
        emptyContentLabel.setAnchors(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: Padding.main, right: view.rightAnchor, paddingRight: Padding.main, centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: nil, height: nil)
        
        view.addSubview(trayCollectionView)
        view.sendSubviewToBack(trayCollectionView)
        trayCollectionView.delegate = self
        trayCollectionView.dataSource = self
//        trayCollectionView.dragDelegate = self
//        trayCollectionView.dropDelegate = self
        trayCollectionView.setAnchors(top: headerLabel.bottomAnchor, paddingTop: 10.0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: nil, height: nil )
        trayCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4, constant: 10.0).isActive = true
    }
    
    override func updateColors() {
        super.updateColors()
        emptyContentLabel.updateColors()
        headerLabel.textColor = ThemeManager.current.accent
        let defaults = UserDefaults.standard
        let image  = defaults.bool(forKey: "dark") ? Image.logoLight : Image.logoDark
        let logoImage = image?.withRenderingMode(.alwaysOriginal).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 8.0, bottom: 0, right: 0))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .done, target: self, action: nil)
        self.navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    private func updateContentForDestructiveAction() {
        guard trayArray.count == 0 else { return }
        trayCollectionView.fadeOut(duration: 1, delay: 0)
        headerLabel.fadeOut(duration: 1, delay: 0)
        emptyContentLabel.fadeIn(duration: 1, delay: 1)
    }
    
    private func updateContentForAdditiveAction() {
        guard trayArray.count == 1 else { return }
        emptyContentLabel.fadeOut(duration: 1, delay: 0)
        trayCollectionView.fadeIn(duration: 1, delay: 1)
        headerLabel.fadeIn(duration: 1, delay: 1)
    }
    
    private func updateContentInitialVisibility() {
        let isContentVisible = (trayArray.count == 0)
        trayCollectionView.isHidden = isContentVisible
        headerLabel.isHidden = isContentVisible
        emptyContentLabel.isHidden = !isContentVisible
    }
    
    
    // MARK: - Edit Controller
    
    @objc private func handleEditGesture(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: self.trayCollectionView)
            if let indexPath = trayCollectionView.indexPathForItem(at: touchPoint) {
                introduceEditController(for: indexPath)
                FeedbackManager.doSelection()
            }
        }
    }
    
    private func introduceEditController(for indexPath: IndexPath) {
        let reversedRow = indexPath.invertRow(arrayLength: self.trayArray.count)
        let tray = trayArray[reversedRow]
        let editController = EditController(for: tray)
        if let trayTitle = tray.title {
            editController.blacklist = getBlacklist(excluding: trayTitle)
        }
        self.present(editController, animated: true, completion: nil)
        
        editController.commitEdits = { (newColor: UIColor?, newTitle: String?) in
            self.editTray(at: IndexPath(row: reversedRow), newColor: newColor, newTitle: newTitle)
        }
        editController.onDeletion = { () in
            editController.dismiss(animated: true) {
//                let reversedRow = indexPath.invertRow(arrayLength: self.trayArray.count)
                self.deleteTray(at: IndexPath(row: reversedRow))
                self.trayCollectionView.deleteItems(at: [indexPath])
            }
        }
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
        guard !defaults.bool(forKey: Identifiers.productID) && (Int.random(in: 1...5) == 1) else { return }
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
        addNewTray(title: text)
    }
    
    
    // MARK: - Data Manipulation
    
    private func saveTrays() {
        do {
            loadBlacklist()
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
    }
    
    private func loadTrays() {
        let request: NSFetchRequest<Tray> = Tray.fetchRequest()
        do {
            trayArray = try context.fetch(request)
            trayCollectionView.reloadData()
            updateContentInitialVisibility()
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    private func addNewTray(title: String) {
        let newTray = Tray(context: context)
        newTray.title = title.trimmingCharacters(in: .whitespaces)
        newTray.color = ThemeColors.themeColors.randomElement()
        trayArray.append(newTray)
        trayCollectionView.insertItems(at: [IndexPath(row: 0)])
        updateContentForAdditiveAction()
        tryAd()
        saveTrays()
    }
    
    private func deleteTray(at indexPath: IndexPath) {
        context.delete(trayArray[indexPath.row])
        trayArray.remove(at: indexPath.row)
        updateContentForDestructiveAction()
        saveTrays()
    }
    
    private func editTray(at indexPath: IndexPath, newColor: UIColor?, newTitle: String?) {
        if let newColor = newColor {
            let color = DataConverter.stringFromColor(color: newColor)
            trayArray[indexPath.row].color = color
        }
        
        if let newTitle = newTitle {
            trayArray[indexPath.row].title = newTitle
        }
        trayCollectionView.reloadData()
        saveTrays()
    }
    
    private func loadBlacklist() {
        headerView.blacklist = getBlacklist()
    }
    
    private func getBlacklist(excluding: String? = nil) -> [String] {
        var blacklist: [String] = []
        for tray in trayArray {
            if let trayTitle = tray.title {
                if excluding == nil {
                    blacklist.append(trayTitle.lowercased())
                } else {
                    if trayTitle != excluding {
                        blacklist.append(trayTitle.lowercased())
                    }
                }
            }
        }
        return blacklist
    }
    
    private func loadTrayProgress(of tray: Tray, with context: NSManagedObjectContext) -> Float {
        let itemFetchRequest = NSFetchRequest<NSDictionary>(entityName: "Item")
        let predicate = NSPredicate(format: "parentTray.title MATCHES %@", tray.title!)
        let completedSortDescriptor = NSSortDescriptor(key: "complete", ascending: true)
        itemFetchRequest.sortDescriptors = [completedSortDescriptor]
        itemFetchRequest.propertiesToFetch = ["complete"]
        itemFetchRequest.resultType = .dictionaryResultType
        itemFetchRequest.predicate = predicate
        do {
            let items: [NSDictionary] = try context.fetch(itemFetchRequest)
            var completeCount: Int = 0
            guard items.count != 0 else { return 0 }
            for item in items {
                if item.value(forKey: "complete") as! Bool {
                    completeCount += 1
                }
            }
            let progress = Float(String(format: "%.2f", Double(completeCount) / Double(items.count)))!
            return progress
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return 0
        }
    }
}

extension TrayController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trayArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let trayData: [Tray] = trayArray.reversed()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trayCell", for: indexPath) as! TrayCell
        cell.setShadow(radius: 8.0, opacity: 0.3, widthOffset: 0.0, heightOffset: 5.0, color: ThemeManager.current.shadow)
        
        let tray = trayData[indexPath.row]
        cell.configureCell(tray: tray, progress: loadTrayProgress(of: tray, with: context))
        
        let editGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleEditGesture(sender:)))
        cell.addGestureRecognizer(editGesture)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height * (0.4)
        let width = height * (175/280)
        let size = CGSize(width: width, height: height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: 0, left: Padding.main, bottom: 0, right: Padding.main)
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Padding.main
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reversedIndex = indexPath.invertRow(arrayLength: trayArray.count)
        let itemController = ItemController(with: trayArray[reversedIndex])
        self.navigationController?.pushViewController(itemController, animated: true)
    }
}

extension TrayController: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
}
//
//extension TrayController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let tray = trayArray[indexPath.row]
//        guard let title = tray.title else { return [] }
//        let itemProvider = NSItemProvider(object: title as NSString)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = tray
//        return [dragItem]
//    }
//
//    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
//        let parameters = UIDragPreviewParameters()
//        let width = view.frame.size.width * 0.533
//        let height = view.frame.size.height * 0.4
//        parameters.visiblePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: 10.0)
//        print("parameters read")
//        return parameters
//    }
//
//    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
//        if collectionView.hasActiveDrag {
//            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
//        } else {
//            return UICollectionViewDropProposal(operation: .forbidden)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//        var destinationIndexPath: IndexPath
//        if let indexPath = coordinator.destinationIndexPath {
//            destinationIndexPath = indexPath
//        } else {
//            let row = collectionView.numberOfItems(inSection: 0)
//            destinationIndexPath = IndexPath(row: row - 1, section: 0)
//        }
//
//        if coordinator.proposal.operation == .move {
//            reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
//            self.saveTrays()
//        }
//    }
//
//    func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
//        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
//            collectionView.performBatchUpdates({
//                let newTray = Tray(context: context)
//                let selectedTray = item.dragItem.localObject as! Tray
//                newTray.title = selectedTray.title
//                newTray.color = selectedTray.color
//                newTray.items = selectedTray.items
//                self.trayArray.remove(at: sourceIndexPath.row)
//                context.delete(trayArray[sourceIndexPath.row])
//                self.trayArray.insert(newTray, at: destinationIndexPath.item)
//                collectionView.deleteItems(at: [sourceIndexPath])
//                collectionView.insertItems(at: [destinationIndexPath])
//                saveTrays()
//            }, completion: nil)
//            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
//        }
//    }
//
//    func printArray() {
//        for tray in trayArray {
//            guard let title = tray.title else { return }
//            print(title)
//        }
//        print("\n")
//    }
//}
