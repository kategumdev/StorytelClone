//
//  ScopeTableSectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/3/23.
//

import UIKit

class ScopeTableSectionHeaderView: UITableViewHeaderFooterView {
    // MARK: - Static property and methods
    static let identifier = "ScopeTableSectionHeaderView"
    
    static func calculateEstimatedHeaderHeight(buttonKind: ScopeButtonKind) -> CGFloat {
        let label = createLabel()
        label.text = "Placeholder"
        label.sizeToFit()
        let height = label.bounds.height + buttonKind.sectionHeaderPaddingY
        return height
    }
    
    static func createLabel() -> UILabel {
        let label = UILabel.createLabelWith(font: UIFont.customCalloutSemibold)
        return label
    }
    
    // MARK: - Instance properties
    private let titleLabel = createLabel()
    private var paddingY: CGFloat = 0
    private var constraintsApplied = false
    
    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureFor(buttonKind: ScopeButtonKind) {
        titleLabel.text = buttonKind.sectionHeaderTitle
        paddingY = buttonKind.sectionHeaderPaddingY
        if !constraintsApplied {
            constraintsApplied = true
            applyConstraints()
        }
    }

    // MARK: - Helper methods
    private func setupUI() {
        contentView.backgroundColor = UIColor.customBackgroundColor
        contentView.addSubview(titleLabel)
    }
    
    private func applyConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.commonHorzPadding),
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: paddingY / 2),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.commonHorzPadding),
            titleLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -paddingY / 2)
        ])
    }
}
