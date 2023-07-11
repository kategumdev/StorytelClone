//
//  SectionHeaderSubviewsContainer.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 2/3/23.
//

import UIKit

// Created as a separate class to enable calculation of estimated section header height and smooth scrolling experience after dynamic font size change
class SectionHeaderSubviewsContainer: UIView {
    
    // Static properties
    private static let paddingBetweenLabelAndButton: CGFloat = 20
    private static let seeAllButtonTitle = "See all"
    private static let paddingBetweenLabels: CGFloat = 1
    
    // MARK: - Instance properties
    private let sectionTitleLabel: UILabel = {
        let label = UILabel.createLabelWith(font: UIFont.customCalloutSemibold, numberOfLines: 2)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let sectionSubtitleLabel: UILabel = {
        let label = UILabel.createLabelWith(font: UIFont.customFootnoteRegular, numberOfLines: 2)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var seeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle(SectionHeaderSubviewsContainer.seeAllButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.customFootnoteSemibold
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.contentHorizontalAlignment = .right
        button.setTitleColor(UIColor.seeAllButtonColor, for: .normal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private lazy var seeAllButtonWidthAnchorConstraint = seeAllButton.widthAnchor.constraint(equalToConstant: 0)
    
    private lazy var vertStackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = SectionHeaderSubviewsContainer.paddingBetweenLabels
        stack.addArrangedSubview(sectionTitleLabel)
        stack.addArrangedSubview(sectionSubtitleLabel)
        return stack
    }()
    
    private lazy var vertStackWithButton: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.addArrangedSubview(UIView())
        stack.addArrangedSubview(seeAllButton)
        return stack
    }()
    
    private lazy var horzStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = SectionHeaderSubviewsContainer.paddingBetweenLabelAndButton
        stack.addArrangedSubview(vertStackWithLabels)
        stack.addArrangedSubview(vertStackWithButton)
        return stack
    }()
    
    private let defaultHorzStackTopPadding: CGFloat = SectionHeaderView.topPadding
    private lazy var horzStackTopAnchorConstraint =             horzStackView.topAnchor.constraint(equalTo: topAnchor, constant: defaultHorzStackTopPadding)
    private var seeAllButtonDidTapCallback: () -> () = {}

    // MARK: - Initializers
    init(addButtonAction: Bool) {
        super.init(frame: .zero)
        addSubview(horzStackView)
        applyConstraints()
        
        // Avoid doind unnecessary job of adding button action to the container that is initialized for estimated header height calculation
        if addButtonAction {
            configureButtonWithAction()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureFor(subCategory: SubCategory, sectionNumber: Int? = nil, category: Category? = nil, forCategoryVcWithReferenceBook: Bool = false, withSeeAllButtonDidTapCallback callback: @escaping () -> () = {}) {
        sectionTitleLabel.text = subCategory.title
        sectionTitleLabel.sizeToFit()
        
        // Show or hide sectionSubtitleLabel
        sectionSubtitleLabel.isHidden = subCategory.subtitle.isEmpty
        sectionSubtitleLabel.text = subCategory.subtitle
        sectionSubtitleLabel.sizeToFit()
        
        // Hide seeAllButton or show and assign/update callback
        let subCategoryKind = subCategory.kind
        if subCategoryKind == .poster || subCategoryKind == .oneBookOverview || subCategoryKind == .largeRectCoversHorzCv || subCategoryKind == .searchVc {
            seeAllButtonWidthAnchorConstraint.isActive = true // Set button width to 0
            horzStackView.spacing = 0
        } else {
            seeAllButtonWidthAnchorConstraint.isActive = false // Reset button to have its intrinsic width
            horzStackView.spacing = SectionHeaderSubviewsContainer.paddingBetweenLabelAndButton
            seeAllButtonDidTapCallback = callback
        }

       // Adjust top padding of first section header if vc is presented when showMoreTitlesLikeThis BookDetailsBottomSheetCell is selected
        guard forCategoryVcWithReferenceBook else { return }
        horzStackTopAnchorConstraint.constant = sectionNumber == 0 ? 15 : defaultHorzStackTopPadding
    }
    
    // MARK: - Helper methods
    private func configureButtonWithAction() {
        seeAllButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.seeAllButtonDidTapCallback()
        }), for: .touchUpInside)
    }
    
    private func applyConstraints() {
        vertStackWithButton.translatesAutoresizingMaskIntoConstraints = false
        vertStackWithButton.widthAnchor.constraint(equalTo: seeAllButton.widthAnchor).isActive = true

        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        seeAllButton.bottomAnchor.constraint(equalTo: vertStackWithLabels.bottomAnchor).isActive = true
        
        horzStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horzStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.commonHorzPadding),
            horzStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.commonHorzPadding),
            horzStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        horzStackTopAnchorConstraint.isActive = true
    }
    
}
