//
//  SearchResultsSectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/3/23.
//

import UIKit

class SearchResultsSectionHeaderView: UITableViewHeaderFooterView {
    // MARK: - Static properties and methods
    static let identifier = "SearchResultsSectionHeaderView"
    static let topAndBottomPadding: CGFloat = 15
    
    static func createLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontForContentSizeCategory = true
        let font = Utils.sectionTitleFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 45)
        label.font = scaledFont
        return label
    }
    
    static func calculateEstimatedHeaderHeight() -> CGFloat {
        let label = createLabel()
        label.text = "Placeholder"
        label.sizeToFit()
        
        let height = label.bounds.height + (topAndBottomPadding * 2)
        return height
    }
    
    // MARK: - Instance properties
    let titleLabel = createLabel()
    
    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Utils.customBackgroundColor
        contentView.addSubview(titleLabel)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureFor(buttonKind: ButtonKind) {
        var titleText = ""
        switch buttonKind {
        case .top: titleText = "Trending searches"
        case .books: titleText = "Trending books"
        case .authors: titleText = "Trending authors"
        case .narrators: titleText = "Trending narrators"
        case .series: titleText = "Trending series"
        case .tags: titleText = "Trending tags"
        }
        titleLabel.text = titleText
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultsSectionHeaderView.topAndBottomPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cvPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SearchResultsSectionHeaderView.topAndBottomPadding)
        ])
    }
    
}
