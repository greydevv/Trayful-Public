//
//  Inputtable.swift
//  Trayful
//
//  Created by Greyson Murray on 9/20/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

protocol Inputtable {
    var onUpdate: ((String) -> ())? { get }
    var inputCharacterLimit: Int? { get set }
    var blacklist: [String] { get set }
    var isActive: Bool { get }
    func confirmEntry()
    func cancelEntry()
}
