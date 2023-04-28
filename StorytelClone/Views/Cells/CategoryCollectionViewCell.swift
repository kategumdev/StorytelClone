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
    private var categoryOfButton: ButtonCategory?

    private lazy var categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let font = Utils.categoryButtonLabelFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 20)
        label.font = scaledFont
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowOpacity = 0.6// Increase opacity for a stronger shadow effect
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
        contentView.addSubview(dimmedAnimationButton)
        dimmedAnimationButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("CategoryCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    // MARK: - Instance methods
    func configure(withColor color: UIColor, categoryOfButton category: ButtonCategory, callback: @escaping DimmedAnimationButtonDidTapCallback) {
        dimmedAnimationButton.backgroundColor = color
        dimmedAnimationButton.categoryButton = category
        dimmedAnimationButton.didTapCallback = callback
        categoryTitleLabel.text = category.rawValue
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        dimmedAnimationButton.translatesAutoresizingMaskIntoConstraints = false
        dimmedAnimationButton.fillSuperview()
        
        categoryTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryTitleLabel.leadingAnchor.constraint(equalTo: dimmedAnimationButton.leadingAnchor, constant: Constants.commonHorzPadding),
            categoryTitleLabel.bottomAnchor.constraint(equalTo: dimmedAnimationButton.bottomAnchor, constant: -(Constants.commonHorzPadding - 4)),
            categoryTitleLabel.trailingAnchor.constraint(equalTo: dimmedAnimationButton.trailingAnchor, constant: -Constants.commonHorzPadding)
        ])
    }
    
}
