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
    static let tableViewSectionSubtitleFont = UIFont.preferredCustomFontWith(weight: .regular, size: 13)
    
    static func getScaledFontForSectionTitle() -> UIFont {
        let font = tableViewSectionTitleFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 45)
        return scaledFont
    }
    
    static func getScaledFontForSectionSubtitle() -> UIFont {
        let font = tableViewSectionSubtitleFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 38)
        return scaledFont
    }
}
