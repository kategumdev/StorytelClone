//
//  BookCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/2/23.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BookCollectionViewCell"
        
    // MARK: - Instance properties
    private let badgeOne = BadgeView()
    private let badgeTwo = BadgeView()
        
    private let dimmedAnimationButton: DimmedAnimationButton = {
        let button = DimmedAnimationButton()
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        button.layer.borderWidth = 0.26
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dimmedAnimationButton)
        contentView.addSubview(badgeOne)
        contentView.addSubview(badgeTwo)

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
    func configureFor(book: Book, withCallback callback: @escaping DimmedAnimationButtonDidTapCallback) {
        if let coverImage = book.coverImage {
//            print("BookCollectionViewCell sets COVER image")
            dimmedAnimationButton.configuration?.background.image = coverImage
        } else {
//            print("BookCollectionViewCell sets PLACEHOLDER image")
            dimmedAnimationButton.configuration?.background.image = UIImageView.placeholderImage
        }
        
        dimmedAnimationButton.kind = .toPushBookVcWith(book)
        dimmedAnimationButton.didTapCallback = callback

        let bookKind = book.titleKind
        if bookKind == .audiobook {
            badgeOne.badgeImageView.image = UIImage(systemName: "headphones")
            badgeOne.isHidden = false
            badgeTwo.isHidden = true
        }
        
        if bookKind == .ebook {
            badgeOne.badgeImageView.image = UIImage(named: "glasses")
            badgeOne.isHidden = false
            badgeTwo.isHidden = true
        }
        
        if bookKind == .audioBookAndEbook {
            badgeOne.badgeImageView.image = UIImage(systemName: "headphones")
            badgeTwo.isHidden = false
            badgeTwo.badgeImageView.image = UIImage(named: "glasses")
        }
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        dimmedAnimationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedAnimationButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dimmedAnimationButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dimmedAnimationButton.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            dimmedAnimationButton.heightAnchor.constraint(equalToConstant: Constants.largeSquareBookCoverSize.height)
        ])
        
        badgeOne.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badgeOne.trailingAnchor.constraint(equalTo: dimmedAnimationButton.trailingAnchor),
            badgeOne.topAnchor.constraint(equalTo: dimmedAnimationButton.topAnchor, constant: -BadgeView.badgeTopAnchorPoints),
            badgeOne.widthAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight),
            badgeOne.heightAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight)
        ])
        
        badgeTwo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badgeTwo.trailingAnchor.constraint(equalTo: badgeOne.leadingAnchor, constant: -BadgeView.paddingBetweenBadges),
            badgeTwo.topAnchor.constraint(equalTo: dimmedAnimationButton.topAnchor, constant: -BadgeView.badgeTopAnchorPoints),
            badgeTwo.widthAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight),
            badgeTwo.heightAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight)
        ])
        
    }

}
