//
//  ColorAwareNavigationController.swift
//  Trayful
//
//  Created by Greyson Murray on 9/13/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class ColorAwareNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "dark") ? .lightContent : .darkContent
    }
    
}
