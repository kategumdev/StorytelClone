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
    
    private lazy var cellButton: DimViewCellButton = {
        let button = DimViewCellButton()
        button.addSubview(categoryTitleLabel)
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cellButton)
        cellButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("CategoryCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    // MARK: - Instance methods
    func configure(withColor color: UIColor, categoryOfButton category: ButtonCategory, callback: @escaping DimViewCellButtonDidTapCallback ) {
        cellButton.backgroundColor = color
        cellButton.categoryButton = category
        cellButton.dimViewCellButtoDidTapCallback = callback
        categoryTitleLabel.text = category.rawValue
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        cellButton.translatesAutoresizingMaskIntoConstraints = false
        cellButton.fillSuperview()
        
        categoryTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryTitleLabel.leadingAnchor.constraint(equalTo: cellButton.leadingAnchor, constant: Constants.commonHorzPadding),
            categoryTitleLabel.bottomAnchor.constraint(equalTo: cellButton.bottomAnchor, constant: -(Constants.commonHorzPadding - 4)),
            categoryTitleLabel.trailingAnchor.constraint(equalTo: cellButton.trailingAnchor, constant: -Constants.commonHorzPadding)
        ])
    }
    
}
