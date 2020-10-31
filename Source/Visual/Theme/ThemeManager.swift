//
//  ThemeManager.swift
//  Trayful
//
//  Created by Greyson Murray on 9/6/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class ThemeManager {
    static var current: ThemeProtocol = LightTheme()
    static var appSignature: UIColor?

    static func setAppSignature(color: UIColor) {
        appSignature = color
    }
    
    static func setCurrent(theme: ThemeProtocol) {
        current = theme
    }
    
    static func getCurrent() -> ThemeProtocol {
        return current
    }

}
