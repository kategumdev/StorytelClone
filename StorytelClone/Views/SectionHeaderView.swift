//
//  SectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/2/23.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Static properties and methods
    static let identifier = "SectionHeaderView"
    
    private static let sectionTitleLabelBottomAnchorConstant: CGFloat = 8
    private static let paddingBetweenLabelAndButton: CGFloat = 20
    private static let seeAllButtonTitle = "See all"
    private static let paddingBetweenLabels: CGFloat = 1
    
    // MARK: - Instance properties
    private let seeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle(seeAllButtonTitle, for: .normal)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
        button.titleLabel?.font = scaledFont
        button.contentHorizontalAlignment = .right
        button.setTitleColor(.label.withAlphaComponent(0.7), for: .normal)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        return button
    }()
    
    let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontForContentSizeCategory = true
        label.font = Utils.getScaledFontForSectionTitle()
        label.backgroundColor = .green
        return label
    }()
    
    let sectionSubtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontForContentSizeCategory = true
        label.font = Utils.getScaledFontForSectionSubtitle()
        label.backgroundColor = .magenta
        return label
    }()

    // MARK: - View life cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(sectionTitleLabel)
        contentView.addSubview(sectionSubtitleLabel)
        contentView.addSubview(seeAllButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    func applyConstraints() {
        
        let seeAllButtonMaxWidth = round(UIScreen.main.bounds.size.width / 3)
        
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
            sectionTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.gapBetweenSectionsOfTablesWithSquareCovers),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: seeAllButton.leadingAnchor, constant: -SectionHeaderView.paddingBetweenLabelAndButton),
            sectionTitleLabel.bottomAnchor.constraint(equalTo: sectionSubtitleLabel.topAnchor, constant: -5)
        ])
        
        sectionSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionSubtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SectionHeaderView.sectionTitleLabelBottomAnchorConstant),
            sectionSubtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
            sectionSubtitleLabel.trailingAnchor.constraint(equalTo: seeAllButton.leadingAnchor, constant: -SectionHeaderView.paddingBetweenLabelAndButton)
        ])
        
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cvPadding),
            seeAllButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SectionHeaderView.sectionTitleLabelBottomAnchorConstant),
            seeAllButton.widthAnchor.constraint(lessThanOrEqualToConstant: seeAllButtonMaxWidth)
        ])
    }

}
