//
//  FeedbackManager.swift
//  Trayful
//
//  Created by Greyson Murray on 9/9/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class FeedbackManager {
    
    static func doImpact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let impact = UIImpactFeedbackGenerator(style: style)
        impact.prepare()
        impact.impactOccurred()
    }
    
    static func doError() {
        let error = UINotificationFeedbackGenerator()
        error.prepare()
        error.notificationOccurred(.error)
    }
    
    static func doSelection() {
        let selection = UISelectionFeedbackGenerator()
        selection.prepare()
        selection.selectionChanged()
    }
    
}
