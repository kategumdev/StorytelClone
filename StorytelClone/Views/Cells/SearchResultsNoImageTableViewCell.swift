//
//  SearchResultsNoImageTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 17/3/23.
//

import UIKit

class SearchResultsNoImageTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultsNoImageTableViewCell"
    
    static func createLabel(withFont font: UIFont, maximumPointSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontForContentSizeCategory = true
        let font = font
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: maximumPointSize)
        label.font = scaledFont
        return label
    }
    
    var storyteller: Storyteller?
    var hashtag: Tag?
    
//    private let authorLabel = 
    
    
}
