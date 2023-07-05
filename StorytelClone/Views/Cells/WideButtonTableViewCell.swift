//
//  WideImageTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 17/2/23.
//

import UIKit

class WideButtonTableViewCell: UITableViewCell {

    static let identifier = "WideImageTableViewCell"
    static let rowHeight: CGFloat = Constants.largeSquareBookCoverSize.height
        
    // MARK: - Instance properties
    private var timeLayoutSubviewsIsBeingCalled = 0

    private lazy var dimmedAnimationButton: DimmedAnimationButton = {
        let button = DimmedAnimationButton()
        button.backgroundColor = UIColor.customCyan
        return button
    }()
    
    let customLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.createScaledFontWith(textStyle: .title1, weight: .bold, basePointSize: 32, maxPointSize: 36)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.customBackgroundColor
        contentView.addSubview(dimmedAnimationButton)
        contentView.addSubview(customLabel)
        dimmedAnimationButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureFor(subCategoryKind: SubCategoryKind, withCallback callback: @escaping DimmedAnimationButtonDidTapCallback) {
        
        if subCategoryKind == .seriesCategoryButton {
            dimmedAnimationButton.kind = .toPushCategoryVcForSeriesCategory
        }
        
        if subCategoryKind == .allCategoriesButton {
            dimmedAnimationButton.kind = .toPushAllCategoriesVc
        }
        
        dimmedAnimationButton.didTapCallback = callback
        customLabel.text = subCategoryKind == .seriesCategoryButton ? "Series" : "Todas las categorías"
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        let buttonWidth = UIScreen.main.bounds.width - Constants.commonHorzPadding * 2
        dimmedAnimationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedAnimationButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            dimmedAnimationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.commonHorzPadding),
            dimmedAnimationButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            dimmedAnimationButton.heightAnchor.constraint(equalToConstant: Constants.largeSquareBookCoverSize.height)
        ])
        
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: dimmedAnimationButton.leadingAnchor, constant: Constants.commonHorzPadding),
            customLabel.trailingAnchor.constraint(equalTo: dimmedAnimationButton.trailingAnchor, constant: -Constants.commonHorzPadding),
            customLabel.bottomAnchor.constraint(equalTo: dimmedAnimationButton.bottomAnchor, constant: -Constants.commonHorzPadding)
        ])
    }
    
}
