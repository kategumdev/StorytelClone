//
//  SearchResultsTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 20/3/23.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {
    
    // MARK: - Static properties and methods
    static let cornerRadius: CGFloat = 2
    static let minTopAndBottomPadding: CGFloat = 13
    static let squareImageWidth: CGFloat = ceil(UIScreen.main.bounds.width * 0.19)
    static let imageHeight: CGFloat = squareImageWidth
    
    static func createTitleLabel(withScaledFont: Bool = true) -> UILabel {
        let label = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, withScaledFont: withScaledFont)
        return label
    }
    
    static func createSubtitleLabel(withScaledFont: Bool = true) -> UILabel {
        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, withScaledFont: withScaledFont)
        return label
    }
    
    static func calculateLabelsHeightWith(subtitleLabelNumber: Int) -> CGFloat {
        let titleLabel = createTitleLabel()
        let subtitleLabel = createSubtitleLabel()
        titleLabel.text = "This is title"
        subtitleLabel.text = "This is subtitle"
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        
//        let labelsHeight = titleLabel.bounds.height + titleLabel.bounds.height * CGFloat(subtitleLabelNumber)
        let labelsHeight = titleLabel.bounds.height + subtitleLabel.bounds.height * CGFloat(subtitleLabelNumber)
        
        return labelsHeight
    }
    
    static func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }
    
    // MARK: - View life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Utils.customBackgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
