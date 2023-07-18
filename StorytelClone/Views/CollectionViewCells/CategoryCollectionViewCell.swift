//
//  CategoryCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
        
    // MARK: - Instance properties
    private var categoryForButton: Category?
    
    private lazy var categoryTitleLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(
            textStyle: .callout,
            weight: .semibold,
            maxPointSize: 20)
        let label = UILabel.createLabelWith(
            font: scaledFont,
            numberOfLines: 0,
            textColor: .white)
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var dimmedAnimationButton: DimmedAnimationButton = {
        let button = DimmedAnimationButton()
        button.addSubview(categoryTitleLabel)
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("CategoryCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    // MARK: - Instance methods
    func configureFor(
        category: Category,
        withCallback callback: @escaping DimmedAnimationBtnDidTapCallback
    ) {
        dimmedAnimationButton.backgroundColor = category.buttonBackgroundColor
        dimmedAnimationButton.kind = .toPushCategoryVcForCategory(category)
        dimmedAnimationButton.didTapCallback = callback
        categoryTitleLabel.text = category.title
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        contentView.addSubview(dimmedAnimationButton)
        dimmedAnimationButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
        applyConstraints()
    }
    
    private func applyConstraints() {
        dimmedAnimationButton.translatesAutoresizingMaskIntoConstraints = false
        dimmedAnimationButton.fillSuperview()
        
        categoryTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryTitleLabel.leadingAnchor.constraint(
                equalTo: dimmedAnimationButton.leadingAnchor,
                constant: Constants.commonHorzPadding),
            categoryTitleLabel.bottomAnchor.constraint(
                equalTo: dimmedAnimationButton.bottomAnchor,
                constant: -(Constants.commonHorzPadding - 4)),
            categoryTitleLabel.trailingAnchor.constraint(
                equalTo: dimmedAnimationButton.trailingAnchor,
                constant: -Constants.commonHorzPadding)
        ])
    }
}
