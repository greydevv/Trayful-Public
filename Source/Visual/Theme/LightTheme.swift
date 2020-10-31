//
//  LightTheme.swift
//  Trayful
//
//  Created by Greyson Murray on 9/6/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class LightTheme: ThemeProtocol {
    var prominent: UIColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    var accent: UIColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1)
    var contrast: UIColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
    var shadow: UIColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    var signature: UIColor = UIColor(red: 43/255, green: 156/255, blue: 255/255, alpha: 1)
    
    func setSignature(color: UIColor) {
        signature = color
    }
}
