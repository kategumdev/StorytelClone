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
    
    private lazy var dimmedAnimationButtonWidthAnchor = dimmedAnimationButton.widthAnchor.constraint(equalToConstant: Constants.largeSquareBookCoverSize.width)
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dimmedAnimationButton)
        contentView.addSubview(badgeOne)
        contentView.addSubview(badgeTwo)
//        weak var weakSelf = self
//        if let weakSelf = weakSelf {
//            dimmedAnimationButton.addConfigurationUpdateHandlerWith(viewToTransform: weakSelf)
//        }
        dimmedAnimationButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
        #warning("not sure if it's okay to pass strong self here")
        applyConstraints()
//        contentView.backgroundColor = .green
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.frame.size.height = TableViewCellWithCollection.rowHeight
////        contentView.frame.size.width = dimmedAnimationButton.bounds.width
//        contentView.frame.size.width = dimmedAnimationButtonWidthAnchor.constant
//    }
    
    // MARK: - Instance methods
//    func configureFor(book: Book, resizedImage: UIImage, withCallback callback: @escaping DimmedAnimationButtonDidTapCallback) {
//        dimmedAnimationButton.kind = .toPushBookVcWith(book)
//        dimmedAnimationButton.didTapCallback = callback
//
//        let bookKind = book.titleKind
//        if bookKind == .audiobook {
//            badgeOne.badgeImageView.image = UIImage(systemName: "headphones")
//            badgeTwo.isHidden = true
//        }
//
//        if bookKind == .ebook {
//            badgeOne.badgeImageView.image = UIImage(named: "glasses")
//            badgeTwo.isHidden = true
//        }
//
//        if bookKind == .audioBookAndEbook {
//            badgeOne.badgeImageView.image = UIImage(systemName: "headphones")
//            badgeTwo.isHidden = false
//            badgeTwo.badgeImageView.image = UIImage(named: "glasses")
//        }
//
//        if dimmedAnimationButton.bounds.width != resizedImage.size.width {
//            dimmedAnimationButtonWidthAnchor.constant = resizedImage.size.width
//        }
//        dimmedAnimationButton.configuration?.background.image = resizedImage
//    }
    
    func configureFor(book: Book, withCallback callback: @escaping DimmedAnimationButtonDidTapCallback) {
        
//        dimmedAnimationButton.setImageForBook(book, buttonWidthConstraint: dimmedAnimationButtonWidthAnchor) { [weak self] in
//            self?.setNeedsLayout()
//            self?.layoutIfNeeded()
//        }
        
//        if dimmedAnimationButton.bounds.width != resizedImage.size.width {
//            dimmedAnimationButtonWidthAnchor.constant = resizedImage.size.width
//        }
        
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
        
//        if dimmedAnimationButton.bounds.width != resizedImage.size.width {
//            dimmedAnimationButtonWidthAnchor.constant = resizedImage.size.width
//        }
//        dimmedAnimationButton.configuration?.background.image = resizedImage
    }
    
    func configureWithPlaceHolder() {
        badgeOne.isHidden = true
        badgeTwo.isHidden = true
        dimmedAnimationButton.configuration?.background.image = UIImageView.placeholderImage
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
//        for constraint in contentView.constraints {
//            constraint.priority = .defaultLow
//        }
//        translatesAutoresizingMaskIntoConstraints = false
//        contentView.widthAnchor.constraint(equalTo: dimmedAnimationButton.widthAnchor).isActive = true
        
        dimmedAnimationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedAnimationButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dimmedAnimationButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dimmedAnimationButton.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            dimmedAnimationButton.heightAnchor.constraint(equalToConstant: Constants.largeSquareBookCoverSize.height)
        ])
//        dimmedAnimationButtonWidthAnchor.isActive = true
//        dimmedAnimationButtonWidthAnchor.priority = .required
//
//        for constraint in contentView.constraints {
//            constraint.priority = .defaultLow
//        }
        
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
////            contentView.widthAnchor.constraint(equalTo: dimmedAnimationButton.widthAnchor),
//            contentView.heightAnchor.constraint(equalToConstant: TableViewCellWithCollection.rowHeight)
//        ])
//        print("dimmedAnimationButton.widthAnchor \(dimmedAnimationButtonWidthAnchor.constant) in applyConstraints")
//        print("dimmedAnimationButton.bounds.width \(dimmedAnimationButton.bounds.width)")
//        print("contentView.bounds.width \(contentView.bounds.width)")
        
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
    
//    private func applyConstraints() {
////        for constraint in contentView.constraints {
////            constraint.priority = .defaultLow
////        }
////        translatesAutoresizingMaskIntoConstraints = false
////        contentView.widthAnchor.constraint(equalTo: dimmedAnimationButton.widthAnchor).isActive = true
//
//        dimmedAnimationButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            dimmedAnimationButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
////            dimmedAnimationButton.topAnchor.constraint(equalTo: contentView.topAnchor),
//            dimmedAnimationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
////            dimmedAnimationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            dimmedAnimationButton.heightAnchor.constraint(equalToConstant: Constants.largeSquareBookCoverSize.height)
//        ])
//        dimmedAnimationButtonWidthAnchor.isActive = true
////        dimmedAnimationButtonWidthAnchor.priority = .required
////
////        for constraint in contentView.constraints {
////            constraint.priority = .defaultLow
////        }
//
////        contentView.translatesAutoresizingMaskIntoConstraints = false
////        NSLayoutConstraint.activate([
//////            contentView.widthAnchor.constraint(equalTo: dimmedAnimationButton.widthAnchor),
////            contentView.heightAnchor.constraint(equalToConstant: TableViewCellWithCollection.rowHeight)
////        ])
////        print("dimmedAnimationButton.widthAnchor \(dimmedAnimationButtonWidthAnchor.constant) in applyConstraints")
////        print("dimmedAnimationButton.bounds.width \(dimmedAnimationButton.bounds.width)")
////        print("contentView.bounds.width \(contentView.bounds.width)")
//
//        badgeOne.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            badgeOne.trailingAnchor.constraint(equalTo: dimmedAnimationButton.trailingAnchor),
//            badgeOne.topAnchor.constraint(equalTo: dimmedAnimationButton.topAnchor, constant: -BadgeView.badgeTopAnchorPoints),
//            badgeOne.widthAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight),
//            badgeOne.heightAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight)
//        ])
//
//        badgeTwo.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            badgeTwo.trailingAnchor.constraint(equalTo: badgeOne.leadingAnchor, constant: -BadgeView.paddingBetweenBadges),
//            badgeTwo.topAnchor.constraint(equalTo: dimmedAnimationButton.topAnchor, constant: -BadgeView.badgeTopAnchorPoints),
//            badgeTwo.widthAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight),
//            badgeTwo.heightAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight)
//        ])
//
//    }
    
//    private func applyConstraints() {
//        dimmedAnimationButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            dimmedAnimationButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            dimmedAnimationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            dimmedAnimationButton.heightAnchor.constraint(equalToConstant: Constants.largeSquareBookCoverSize.height)
//        ])
//        dimmedAnimationButtonWidthAnchor.isActive = true
//
//        badgeOne.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            badgeOne.trailingAnchor.constraint(equalTo: dimmedAnimationButton.trailingAnchor),
//            badgeOne.topAnchor.constraint(equalTo: dimmedAnimationButton.topAnchor, constant: -BadgeView.badgeTopAnchorPoints),
//            badgeOne.widthAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight),
//            badgeOne.heightAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight)
//        ])
//
//        badgeTwo.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            badgeTwo.trailingAnchor.constraint(equalTo: badgeOne.leadingAnchor, constant: -BadgeView.paddingBetweenBadges),
//            badgeTwo.topAnchor.constraint(equalTo: dimmedAnimationButton.topAnchor, constant: -BadgeView.badgeTopAnchorPoints),
//            badgeTwo.widthAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight),
//            badgeTwo.heightAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight)
//        ])
//    }
    
}
