//
//  Date_Ext.swift
//  Trayful
//
//  Created by Greyson Murray on 9/9/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

extension Date {
    func getDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: self).capitalized
    }
}
