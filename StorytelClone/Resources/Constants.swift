//
//  Constants.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 17/2/23.
//

import UIKit

// reusable in different controllers and views
struct Constants {
    
    static let cvPadding: CGFloat = 18
    static let gapBetweenSectionsOfTablesWithSquareCovers: CGFloat = 31
    static let visibleSquareCvItemsInRow: CGFloat = 3 // the 3rd one is only half visible
    static let bookCoverCornerRadius: CGFloat = 4
    
    //MARK: - Calculated
    static let calculatedSquareCoverSize: CGSize = {
        let contentViewWidth = UIScreen.main.bounds.width
        let width = (contentViewWidth - Constants.cvPadding * Constants.visibleSquareCvItemsInRow) / Constants.visibleSquareCvItemsInRow
        
        let fullWidth = contentViewWidth + (width / 2)
        let itemWidth = (fullWidth - Constants.cvPadding
                         * Constants.visibleSquareCvItemsInRow) / Constants.visibleSquareCvItemsInRow
    
        let size = CGSize(width: round(itemWidth), height: round(itemWidth))
        return size
    }()
    
    static let calculatedCvItemSizeSquareCovers: CGSize = {
        let width = calculatedSquareCoverSize.width
        let height = calculatedSquareCoverSize.height + BadgeView.topAnchorPoints
        let size = CGSize(width: width, height: height)
        return size
    }()
    
    static let heightForRowWithSquareCoversCv: CGFloat = {
        return calculatedCvItemSizeSquareCovers.height
    }()

}
