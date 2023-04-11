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
    
//    private lazy var dimViewForButtonAnimation: UIView = {
//        let view = UIView()
//        view.backgroundColor = Utils.customBackgroundColor
//        return view
//    }()
    
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
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cellButton)
//        contentView.addSubview(dimViewForButtonAnimation)
        
//        addButtonUpdateHandler()
//        cellButton.addConfigurationUpdateHandlerWith(viewToTransform: self, viewToChangeAlpha: dimViewForButtonAnimation)
        cellButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("CategoryCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    // MARK: - Helper methods
    func configure(withColor color: UIColor, categoryOfButton category: ButtonCategory, callback: @escaping ButtonCallback ) {
        cellButton.backgroundColor = color
        cellButton.categoryButton = category
        cellButton.callback = callback
        categoryTitleLabel.text = category.rawValue
    }
    
    private func applyConstraints() {
//        dimViewForButtonAnimation.translatesAutoresizingMaskIntoConstraints = false
//        dimViewForButtonAnimation.fillSuperview()

        cellButton.translatesAutoresizingMaskIntoConstraints = false
        cellButton.fillSuperview()
        
        categoryTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryTitleLabel.leadingAnchor.constraint(equalTo: cellButton.leadingAnchor, constant: Constants.cvPadding),
            categoryTitleLabel.bottomAnchor.constraint(equalTo: cellButton.bottomAnchor, constant: -(Constants.cvPadding - 4)),
            categoryTitleLabel.trailingAnchor.constraint(equalTo: cellButton.trailingAnchor, constant: -Constants.cvPadding)
        ])
    }
    
}
