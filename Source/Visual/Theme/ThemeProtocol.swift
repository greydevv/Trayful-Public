//
//  ThemeProtocol.swift
//  Trayful
//
//  Created by Greyson Murray on 9/6/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

protocol ThemeProtocol {
    var prominent: UIColor { get } // Backgrounds, etc. (most prominent color)
    var accent: UIColor { get } // Off-shade of prominent
    var contrast: UIColor { get }
    var shadow: UIColor { get } // Cell shadows
    var signature: UIColor { get } // Trayful blue or color of selected Tray in ItemController
    
    func setSignature(color: UIColor)
}
