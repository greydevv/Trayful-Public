//
//  DataConverter.swift
//  Trayful
//
//  Created by Greyson Murray on 8/11/20.
//  Copyright © 2020 Greyson Murray. All rights reserved.
//

import UIKit

class DataConverter {
    
    private static let colorData: [String:UIColor] = ["darkBlue":ThemeColors.darkBlue,
                                       "pink":ThemeColors.pink,
                                       "deepPink":ThemeColors.deepPink,
                                       "blue":ThemeColors.blue,
                                       "gray":ThemeColors.gray,
                                       "blueGreen":ThemeColors.blueGreen,
                                       "purple":ThemeColors.purple]
    
    // converts String to UIColor based on contents of colorData
    static func colorFromString(color: String!) -> UIColor {
        guard let color = colorData[color] else { return ThemeColors.purple}
        return color
    }
    
    // converts UIColor to String based on contents of colorData
    static func stringFromColor(color: UIColor!) -> String {
        let values = colorData.values
        guard let index = values.firstIndex(of: color) else { return "purple" }
        return colorData.keys[index]
    }
    
    // formats String for grammatical correctness based on if a number is more than one
    static func formatPlural(number: Int, singularString string: String) -> String {
        if (number != 1) {
            return "\(number) \(string)s"
        } else {
            return "\(number) \(string)"
        }
    }
    
    static func formatPercentage(percentage: Float) -> String {
        let string = String("\(Int(percentage * 100))%")
        return string
    }
}
