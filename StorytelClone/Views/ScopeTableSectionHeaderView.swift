//
//  SearchResultsSectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/3/23.
//

import UIKit

class ScopeTableSectionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Static properties and methods
    static let identifier = "SearchResultsTableSectionHeaderView"
    
    static func createLabel() -> UILabel {
        let label = UILabel.createLabelWith(font: UIFont.customCalloutSemibold)
        return label
    }
    
    static func calculateEstimatedHeaderHeight(buttonKind: ScopeButtonKind) -> CGFloat {
        let label = createLabel()
        label.text = "Placeholder"
        label.sizeToFit()
        let topAndBottomPadding = buttonKind.sectionHeaderTopAndBottomPadding
        let height = label.bounds.height + (topAndBottomPadding * 2)
        return height
    }
    
    // MARK: - Instance properties
    private let titleLabel = createLabel()
    private var topAndBottomPadding: CGFloat = 0
    private var constraintsApplied = false
    
    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.customBackgroundColor
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureFor(buttonKind: ScopeButtonKind) {
        titleLabel.text = buttonKind.sectionHeaderTitle
        topAndBottomPadding = buttonKind.sectionHeaderTopAndBottomPadding
        if !constraintsApplied {
            constraintsApplied = true
            applyConstraints()
        }
    }

    // MARK: - Helper methods
    private func applyConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.commonHorzPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topAndBottomPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.commonHorzPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -topAndBottomPadding)
        ])
    }
}
