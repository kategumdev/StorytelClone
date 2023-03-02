//
//  SectionHeaderSubviewsContainer.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 2/3/23.
//

import UIKit

// Create it as a separate class to make calculation of estimated section header height (and smooth scrolling experience, especially after dynamic font size change) possible
class SectionHeaderSubviewsContainer: UIView {
    
    // MARK: Static properties and methods
    private static let sectionTitleLabelBottomAnchorConstant: CGFloat = 8
    private static let paddingBetweenLabelAndButton: CGFloat = 20
    private static let seeAllButtonTitle = "See all"
    private static let paddingBetweenLabels: CGFloat = 1
    
//    static let seeAllButton: UIButton = {
//        let button = UIButton()
//        button.setTitle(seeAllButtonTitle, for: .normal)
//        button.titleLabel?.lineBreakMode = .byTruncatingTail
//        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
//        button.titleLabel?.font = scaledFont
//        button.contentHorizontalAlignment = .right
//        button.setTitleColor(.label.withAlphaComponent(0.7), for: .normal)
//        button.titleLabel?.adjustsFontForContentSizeCategory = true
//        return button
//    }()
    
    private static func createSeeAllButton() -> UIButton {
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
    }
    
    static func calculateHeaderHeightFor(section: TableSection) -> CGFloat {
        let header = SectionHeaderSubviewsContainer()
        header.sectionTitleLabel.text = section.sectionTitle
        header.sectionSubtitleLabel.text = section.sectionSubtitle
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    
    private static func calculateSeeAllButtonWidth() -> CGFloat {
//        let button = UIButton()
//        button.setTitle(seeAllButtonTitle, for: .normal)
//        button.titleLabel?.lineBreakMode = .byTruncatingTail
//        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
//        button.titleLabel?.font = scaledFont
//        button.contentHorizontalAlignment = .right
        let button = createSeeAllButton()
        button.sizeToFit()
        return button.bounds.size.width
    }
    
    // MARK: - Instance properties
//    let seeAllButton: UIButton = {
//        let button = UIButton()
//        button.setTitle(seeAllButtonTitle, for: .normal)
//        button.titleLabel?.lineBreakMode = .byTruncatingTail
//        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
//        button.titleLabel?.font = scaledFont
//        button.contentHorizontalAlignment = .right
//        button.setTitleColor(.label.withAlphaComponent(0.7), for: .normal)
//        button.titleLabel?.adjustsFontForContentSizeCategory = true
//        return button
//    }()
    
    private let seeAllButton = SectionHeaderSubviewsContainer.createSeeAllButton()
    
    let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontForContentSizeCategory = true
        let font = Utils.tableViewSectionTitleFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 45)
        label.font = scaledFont
        return label
    }()
    
    let sectionSubtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontForContentSizeCategory = true
        let font = Utils.tableViewSectionSubtitleFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 38)
        label.font = scaledFont
        return label
    }()

    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sectionTitleLabel)
        addSubview(sectionSubtitleLabel)
        addSubview(seeAllButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
            sectionTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.gapBetweenSectionsOfCategoryTable),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: seeAllButton.leadingAnchor, constant: -SectionHeaderSubviewsContainer.paddingBetweenLabelAndButton),
            sectionTitleLabel.bottomAnchor.constraint(equalTo: sectionSubtitleLabel.topAnchor, constant: -5)
        ])
        
        sectionSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionSubtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SectionHeaderSubviewsContainer.sectionTitleLabelBottomAnchorConstant),
            sectionSubtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cvPadding),
            sectionSubtitleLabel.trailingAnchor.constraint(equalTo: seeAllButton.leadingAnchor, constant: -SectionHeaderSubviewsContainer.paddingBetweenLabelAndButton)
        ])
        
//        let seeAllButtonMaxWidth = round(UIScreen.main.bounds.size.width / 3)
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cvPadding),
            seeAllButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SectionHeaderSubviewsContainer.sectionTitleLabelBottomAnchorConstant),
//            seeAllButton.widthAnchor.constraint(equalToConstant: seeAllButtonMaxWidth)
            seeAllButton.widthAnchor.constraint(equalToConstant: SectionHeaderSubviewsContainer.calculateSeeAllButtonWidth())
        ])
    }

}

