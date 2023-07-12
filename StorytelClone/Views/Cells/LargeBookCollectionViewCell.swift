//
//  LargeBookCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 5/3/23.
//

import UIKit

class LargeBookCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LargeBookCollectionViewCell"
        
    // MARK: - Instance properties
    private let dimmedAnimationButton: DimmedAnimationButton = {
        let button = DimmedAnimationButton()
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        button.layer.borderWidth = 0.26
        return button
    }()
    
    private let coverCornerRadius: CGFloat = 7
        
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dimmedAnimationButton)
        dimmedAnimationButton.layer.cornerRadius = coverCornerRadius
        dimmedAnimationButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("BookCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    // MARK: - View life cycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            dimmedAnimationButton.layer.borderColor = UIColor.tertiaryLabel.cgColor
        }
    }
    
    // MARK: - Instance methods
    func configureFor(book: Book, withCallback callback: @escaping DimmedAnimationBtnDidTapCallback) {
        dimmedAnimationButton.kind = .toPushBookVcWith(book)
        dimmedAnimationButton.didTapCallback = callback
        dimmedAnimationButton.configuration?.background.image = book.coverImage
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        dimmedAnimationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedAnimationButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topPaddingForPosterAndLargeRectCoversCells),
            dimmedAnimationButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dimmedAnimationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dimmedAnimationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
}
