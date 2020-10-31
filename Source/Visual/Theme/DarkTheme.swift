//
//  DarkTheme.swift
//  Trayful
//
//  Created by Greyson Murray on 9/6/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class DarkTheme: ThemeProtocol {
    var prominent: UIColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
    var accent: UIColor = UIColor(red: 72/255, green: 72/255, blue: 72/255, alpha: 1)
    var contrast: UIColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    var shadow: UIColor = UIColor(red: 5/255, green: 5/255, blue: 5/255, alpha: 1)
    var signature: UIColor = UIColor(red: 43/255, green: 156/255, blue: 255/255, alpha: 1)
    
    func setSignature(color: UIColor) {
        signature = color
    }
}
