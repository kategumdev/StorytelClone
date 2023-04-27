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
        bookButton.layer.cornerRadius = Constants.largeCoverCornerRadius
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
    func configureFor(book: Book, withCallback callback: @escaping DimViewCellButtonDidTapCallback) {
        bookButton.book = book
        bookButton.dimViewCellButtoDidTapCallback = callback
        bookButton.configuration?.background.image = book.largeCoverImage
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.posterAndLargeCoversCellTopPadding),
            bookButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bookButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
}
