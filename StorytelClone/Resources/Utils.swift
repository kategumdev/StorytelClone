//
//  Utils.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 21/2/23.
//

import UIKit

struct Utils {
    
    static let navBarTitleFont = UIFont.preferredCustomFontWith(weight: .semibold, size: 16)
    
    static let tableViewSectionTitleFont = UIFont.preferredCustomFontWith(weight: .semibold, size: 16)
    
    static func getScaledFontForSectionTitle() -> UIFont {
        let font = tableViewSectionTitleFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 42)
        return scaledFont
    }
}
