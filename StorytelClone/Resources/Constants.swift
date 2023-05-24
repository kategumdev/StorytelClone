//
//  Constants.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 17/2/23.
//

import UIKit

struct Constants {
    
    static let commonHorzPadding: CGFloat = 16
    static let commonBookCoverCornerRadius: CGFloat = 4
    static let topPaddingForCellsWithPosterAndLargeRectangleCovers: CGFloat = 10
    static let numberOfVisibleCvItemsInRow: CGFloat = 3 // the 3rd one is only partly visible
    
    static let largeSquareBookCoverSize: CGSize = {
        let contentViewWidth = UIScreen.main.bounds.width
        let width = (contentViewWidth - commonHorzPadding * numberOfVisibleCvItemsInRow) / numberOfVisibleCvItemsInRow

        let fullWidth = contentViewWidth + (width / 2)
        let itemWidth = (fullWidth - commonHorzPadding * numberOfVisibleCvItemsInRow) / numberOfVisibleCvItemsInRow

        let size = CGSize(width: round(itemWidth), height: round(itemWidth))
        return size
    }()
    
    static let mediumSquareBookCoverSize: CGSize = {
        let width = round(4/5 * largeSquareBookCoverSize.width)
        let height = width
        return CGSize(width: width, height: height)
    }()
    
    static let smallSquareBookCoverSize: CGSize = {
        let width: CGFloat = ceil(UIScreen.main.bounds.width * 0.19)
        let size = CGSize(width: width, height: width)
        return size
    }()
}
