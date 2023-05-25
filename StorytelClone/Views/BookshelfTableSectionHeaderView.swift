//
//  BookshelfTableSectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 2/5/23.
//

import UIKit

class BookshelfTableSectionHeaderView: UITableViewHeaderFooterView {
    // MARK: - Static properties and methods
    static let identifier = "BookshelfTableSectionHeaderView"
    static let topAndBottomPadding: CGFloat = 6

    static func createLabel() -> UILabel {
        let label = UILabel.createLabelWith(font: UIFont.customCalloutSemibold)
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
        contentView.backgroundColor = UIColor.customBackgroundColor
        contentView.addSubview(titleLabel)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configurefor(buttonKind: ScopeButtonKind) {
        titleLabel.text = buttonKind.sectionHeaderTitle
//        titleLabel.text = ScopeButtonKind.getSectionHeaderTitleFor(kind: buttonKind)
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.commonHorzPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: BookshelfTableSectionHeaderView.topAndBottomPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.commonHorzPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -BookshelfTableSectionHeaderView.topAndBottomPadding)
        ])
    }

}
