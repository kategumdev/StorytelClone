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
        
    private let bookButton: DimViewCellButton = {
        let button = DimViewCellButton()
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        button.layer.borderWidth = 0.26
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bookButton)
        contentView.addSubview(badgeOne)
        contentView.addSubview(badgeTwo)
        bookButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("BookCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    // MARK: - View life cycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            bookButton.layer.borderColor = UIColor.tertiaryLabel.cgColor
        }
    }
    
    // MARK: - Instance methods
    func configureFor(book: Book, withCallbackForButton callback: @escaping ButtonCallback) {
        bookButton.book = book
        bookButton.callback = callback
        
        bookButton.configuration?.background.image = book.coverImage

        let bookKind = book.titleKind
        if bookKind == .audiobook {
            badgeOne.badgeImageView.image = UIImage(systemName: "headphones")
            badgeTwo.isHidden = true
        }
        
        if bookKind == .ebook {
            badgeOne.badgeImageView.image = UIImage(named: "glasses")
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
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bookButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookButton.widthAnchor.constraint(equalToConstant: Utils.calculatedSquareCoverSize.width),
            bookButton.heightAnchor.constraint(equalToConstant: Utils.calculatedSquareCoverSize.height)
        ])
        
        badgeOne.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badgeOne.trailingAnchor.constraint(equalTo: bookButton.trailingAnchor),
            badgeOne.topAnchor.constraint(equalTo: bookButton.topAnchor, constant: -BadgeView.badgeTopAnchorPoints),
            badgeOne.widthAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight),
            badgeOne.heightAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight)
        ])
        
        badgeTwo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badgeTwo.trailingAnchor.constraint(equalTo: badgeOne.leadingAnchor, constant: -BadgeView.paddingBetweenBadges),
            badgeTwo.topAnchor.constraint(equalTo: bookButton.topAnchor, constant: -BadgeView.badgeTopAnchorPoints),
            badgeTwo.widthAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight),
            badgeTwo.heightAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight)
        ])
    }
    
}
