//
//  SearchResultsSectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/3/23.
//

import UIKit

class SearchResultsTableSectionHeaderView: UITableViewHeaderFooterView {
    // MARK: - Static properties and methods
    static let identifier = "SearchResultsTableSectionHeaderView"
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
    private let titleLabel = createLabel()
    
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

    // MARK: - Helper methods
    private func applyConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.commonHorzPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultsTableSectionHeaderView.topAndBottomPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.commonHorzPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SearchResultsTableSectionHeaderView.topAndBottomPadding)
        ])
    }
    
}
