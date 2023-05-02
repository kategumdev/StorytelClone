//
//  SearchResultsSectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/3/23.
//

import UIKit

//enum SectionHeaderTopAndBottomPadding: CGFloat {
//    case forSearchResults = 15
//    case forBookshelf = 12
//}

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
    
//    static func calculateEstimatedHeighWith(topAndBottomPadding: CGFloat) -> CGFloat {
//        let label = createLabel()
//        label.text = "Placeholder"
//        label.sizeToFit()
//
//        let height = label.bounds.height + (topAndBottomPadding * 2)
//        return height
//    }
    
    static func calculateEstimatedHeaderHeight() -> CGFloat {
        let label = createLabel()
        label.text = "Placeholder"
        label.sizeToFit()

        let height = label.bounds.height + (topAndBottomPadding * 2)
        return height
    }
    
    // MARK: - Instance properties
//    private var topAndBottomPadding: CGFloat = 0
//    private var topAndBottomPadding: CGFloat = 15
    
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
    func configurefor(buttonKind: ScopeButtonKind) {
        titleLabel.text = ScopeButtonKind.getSectionHeaderTitleFor(kind: buttonKind)
    }
//    func configureWith(topAndBottomPadding: CGFloat, forButtonKind buttonKind: ScopeButtonKind) {
//        self.topAndBottomPadding = topAndBottomPadding
//
//        titleLabel.text = ScopeButtonKind.getSectionHeaderTitleFor(kind: buttonKind)
//    }
    
//    func configureFor(buttonKind: ScopeButtonKind) {
//        var titleText = ""
//        switch buttonKind {
//        case .top: titleText = "Trending searches"
//        case .books: titleText = "Trending books"
//        case .authors: titleText = "Trending authors"
//        case .narrators: titleText = "Trending narrators"
//        case .series: titleText = "Trending series"
//        case .tags: titleText = "Trending tags"
//        case .toRead: titleText = "Past 7 days"
//        case .started: titleText = ""
//        case .finished: titleText = ""
//        case .downloaded: titleText = ""
//        }
//        titleLabel.text = titleText
//    }
    
//    func configureFor(buttonKind: ScopeButtonKind) {
//        var titleText = ""
//        switch buttonKind {
//        case .top: titleText = "Trending searches"
//        case .books: titleText = "Trending books"
//        case .authors: titleText = "Trending authors"
//        case .narrators: titleText = "Trending narrators"
//        case .series: titleText = "Trending series"
//        case .tags: titleText = "Trending tags"
//        }
//        titleLabel.text = titleText
//    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.commonHorzPadding),
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultsSectionHeaderView.topAndBottomPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultsSectionHeaderView.topAndBottomPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.commonHorzPadding),
//            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SearchResultsSectionHeaderView.topAndBottomPadding)
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SearchResultsSectionHeaderView.topAndBottomPadding)
        ])
    }
    
}
