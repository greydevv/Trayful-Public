//
//  NoFadeUICollectionViewFlowLayout.swift
//  Trayful
//
//  Created by Greyson Murray on 5/7/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class NoFadeUICollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        attrs?.alpha = 1.0
        return attrs
    }

    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        attrs?.alpha = 1.0
        return attrs
    }
    
}
