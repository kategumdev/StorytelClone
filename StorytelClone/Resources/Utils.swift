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
    
//    static let calculatedSquareCoverSize: CGSize = {
//        let contentViewWidth = UIScreen.main.bounds.width
//        let width = (contentViewWidth - Constants.cvLeftRightPadding * Constants.visibleSquareCvItemsInRow) / Constants.visibleSquareCvItemsInRow
//        
//        let fullWidth = contentViewWidth + (width / 2)
//        let itemWidth = (fullWidth - Constants.cvLeftRightPadding
//                         * Constants.visibleSquareCvItemsInRow) / Constants.visibleSquareCvItemsInRow
//    
//        let size = CGSize(width: round(itemWidth), height: round(itemWidth))
//        return size
//    }()
//    
//    static let calculatedSquareCvItemSize: CGSize = {
//        let width = calculatedSquareCoverSize.width + Constants.cvLeftRightPadding
//        let height = calculatedSquareCoverSize.height + BadgeView.topAnchorPoints
//        let size = CGSize(width: width, height: height)
//        return size
//    }()
//    
//    static let heightForRowWithSquareCoversCv: CGFloat = {
//        return calculatedSquareCvItemSize.height
//    }()
}
