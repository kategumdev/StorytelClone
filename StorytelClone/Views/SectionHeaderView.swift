//
//  SectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/2/23.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {

    static let identifier = "SectionHeaderView"
    
    private static let sectionTitleLabelBottomAnchorConstant: CGFloat = 7
    private static let paddingBetweenLabelAndButton: CGFloat = 20
    private static let seeAllButtonTitle = "See all"

    static func calculateSectionLabelHeightWith(title: String) -> CGFloat {
        let label = createSectionTitleLabel()
        label.text = title

        let size = label.sizeThatFits(CGSize(width: sectionTitleLabelWidth(), height: .greatestFiniteMagnitude))
        let labelHeight = size.height
        
        let paddings: CGFloat = Constants.gapBetweenSectionsOfTablesWithSquareCovers + sectionTitleLabelBottomAnchorConstant
        let sectionHeight = labelHeight + paddings

        return sectionHeight
    }
    
    private static func sectionTitleLabelWidth() -> CGFloat {
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
    
    private static func createSeeAllButton() -> UIButton {
        let button = UIButton()
        button.setTitle(seeAllButtonTitle, for: .normal)
        button.titleLabel?.numberOfLines = 1
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
        label.preferredMaxLayoutWidth = sectionTitleLabelWidth()
        label.adjustsFontForContentSizeCategory = true
        label.font = Utils.getScaledFontForSectionTitle()
        return label
    }
    
    private let seeAllButton = createSeeAllButton()
    
    let sectionTitleLabel = createSectionTitleLabel()

    // MARK: - View life cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(sectionTitleLabel)
        contentView.addSubview(seeAllButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    func applyConstraints() {

        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let sectionTitleLabelConstraints = [
            sectionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
            sectionTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SectionHeaderView.sectionTitleLabelBottomAnchorConstant),
        ]
        NSLayoutConstraint.activate(sectionTitleLabelConstraints)
        
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        guard let widthConstant = seeAllButton.titleLabel?.preferredMaxLayoutWidth else { return }
        let seeAllButtonConstraints = [
            seeAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cvPadding),
            seeAllButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            seeAllButton.widthAnchor.constraint(lessThanOrEqualToConstant: widthConstant)
        ]
        NSLayoutConstraint.activate(seeAllButtonConstraints)
    }
    
}
