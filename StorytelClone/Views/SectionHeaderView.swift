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
    
    private static var sectionTitleLabelWidth: CGFloat {
        // Get width of seeAllButton
        let button = createSeeAllButton() // Create seeAllButton right before calculating width to account for current dynamic font size
        guard let label = button.titleLabel else { return 0 }

        let size = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))

        // Calculated width can result in more than maxWidth, avoid it
        let maxWidth = label.preferredMaxLayoutWidth
        let seeAllButtonWidth: CGFloat
        if size.width > maxWidth {
            seeAllButtonWidth = maxWidth
        } else {
            seeAllButtonWidth = ceil(size.width)
        }

        // Calculate width of section title label
        let sectionLabelWidth = UIScreen.main.bounds.width - (Constants.cvPadding * 2) - seeAllButtonWidth - paddingBetweenLabelAndButton
        return sectionLabelWidth
    }
    
    static func calculateSectionHeightWith(title: String, subtitle: String) -> CGFloat {
        let titleLabel = createSectionTitleLabel()
        titleLabel.text = title
        let titleLabelSize = titleLabel.sizeThatFits(CGSize(width: sectionTitleLabelWidth, height: .greatestFiniteMagnitude))
        let titleLabelHeight = titleLabelSize.height
        
        let subtitleLabelHeight: CGFloat
        if !subtitle.isEmpty {
            let subtitleLabel = createSectionTitleLabel()
            subtitleLabel.text = subtitle
            let subtitleLabelSize = subtitleLabel.sizeThatFits(CGSize(width: sectionTitleLabelWidth, height: .greatestFiniteMagnitude))
            subtitleLabelHeight = subtitleLabelSize.height
        } else {
            subtitleLabelHeight = 0
        }
        
        let paddings: CGFloat
        if !subtitle.isEmpty {
            paddings = Constants.gapBetweenSectionsOfTablesWithSquareCovers + sectionTitleLabelBottomAnchorConstant + paddingBetweenLabels
        } else {
        paddings = Constants.gapBetweenSectionsOfTablesWithSquareCovers + sectionTitleLabelBottomAnchorConstant
        }
        
        let sectionHeight = titleLabelHeight + subtitleLabelHeight + paddings
        return sectionHeight
    }

    private static func createSeeAllButton() -> UIButton {
        let button = UIButton()
        button.setTitle(seeAllButtonTitle, for: .normal)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.preferredMaxLayoutWidth =  round(UIScreen.main.bounds.size.width / 3) // needed to calculate button width
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
        button.titleLabel?.font = scaledFont
        button.setTitleColor(.label.withAlphaComponent(0.7), for: .normal)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        return button
    }
    
    private static func createSectionTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.preferredMaxLayoutWidth = sectionTitleLabelWidth
        label.adjustsFontForContentSizeCategory = true
        label.font = Utils.getScaledFontForSectionTitle()
        return label
    }
    
    private static func createSectionSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.preferredMaxLayoutWidth = sectionTitleLabelWidth
        label.adjustsFontForContentSizeCategory = true
        label.font = Utils.getScaledFontForSectionSubtitle()
        return label
    }
    
    // MARK: Instance properties
    private let seeAllButton = createSeeAllButton()
    
    let sectionTitleLabel = createSectionTitleLabel()
    var sectionSubtitleLabel = createSectionSubtitleLabel()
    
    lazy var sectionTitleLabelBottomAnchor = sectionTitleLabel.bottomAnchor.constraint(equalTo: sectionSubtitleLabel.topAnchor, constant: -SectionHeaderView.paddingBetweenLabels)
    lazy var seeAllButtonAnchorIfNoSubtitle = seeAllButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
    lazy var seeAllButtonAnchorIfSubtitle = seeAllButton.centerYAnchor.constraint(equalTo: sectionSubtitleLabel.centerYAnchor)
    
    var hasSubtitle = false {
        didSet {
            seeAllButtonAnchorIfSubtitle.isActive = hasSubtitle
            seeAllButtonAnchorIfNoSubtitle.isActive = !hasSubtitle
            sectionTitleLabelBottomAnchor.constant = hasSubtitle == true ? -SectionHeaderView.paddingBetweenLabels : 0
        }
    }

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

        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding).isActive = true
        sectionTitleLabelBottomAnchor.isActive = true
        
        sectionSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionSubtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
            sectionSubtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SectionHeaderView.sectionTitleLabelBottomAnchorConstant)
        ])

        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        guard let widthConstant = seeAllButton.titleLabel?.preferredMaxLayoutWidth else { return }
        seeAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cvPadding).isActive = true
        seeAllButton.widthAnchor.constraint(lessThanOrEqualToConstant: widthConstant).isActive = true
        seeAllButtonAnchorIfNoSubtitle.isActive = true
    }
    
}
