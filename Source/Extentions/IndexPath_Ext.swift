//
//  IndexPath_Ext.swift
//  Trayful
//
//  Created by Greyson Murray on 10/1/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import Foundation

extension IndexPath {
    
    init(row: Int) {
        self.init(row: row, section: 0)
    }
    
    func invertRow(arrayLength: Int) -> Int {
        let invertedRow = ((arrayLength - self.row) - 1)
        return invertedRow
    }
    
}
