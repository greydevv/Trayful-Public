//
//  UITextField_Ext.swift
//  Trayful
//
//  Created by Greyson Murray on 9/9/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

extension UITextField {
    
    func isValid(characterLimit: Int, blacklist: [String]) -> Bool {
        guard let text = self.text?.trimmingCharacters(in: .whitespaces) else { handleInvalidity(); return false }
        guard !isEmpty() && !blacklist.contains(text.lowercased()) else { handleInvalidity(); return false }
        if text.count > characterLimit {
            let prefixedTitle = text.prefix(characterLimit)
            self.text = String(prefixedTitle)
        }
        return true
    }
    
    func handleInvalidity() {
        clear()
        errorShake()
    }
    
    func clear() {
        self.text = ""
    }
    
    func isEmpty() -> Bool {
        return (self.text?.replacingOccurrences(of: " ", with: "") == "") || (self.text == ".")
    }
}
