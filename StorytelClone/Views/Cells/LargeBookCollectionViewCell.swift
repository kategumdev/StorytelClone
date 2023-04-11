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
    
//    private lazy var dimViewForButtonAnimation: UIView = {
//        let view = UIView()
//        view.backgroundColor = Utils.customBackgroundColor
//        return view
//    }()
        
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bookButton)
        bookButton.layer.cornerRadius = Constants.largeCoverCornerRadius
//        contentView.addSubview(dimViewForButtonAnimation)
        
//        addButtonUpdateHandler()
//        bookButton.addConfigurationUpdateHandlerWith(viewToTransform: self, viewToChangeAlpha: dimViewForButtonAnimation)
        bookButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("BookCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            bookButton.layer.borderColor = UIColor.tertiaryLabel.cgColor
        }
    }
    
    // MARK: - Helper methods
    func configureFor(book: Book, withCallbackForButton callback: @escaping ButtonCallback) {
        bookButton.book = book
        bookButton.callback = callback
        bookButton.configuration?.background.image = book.largeCoverImage
    }
    
    private func applyConstraints() {
//        dimViewForButtonAnimation.translatesAutoresizingMaskIntoConstraints = false
//        dimViewForButtonAnimation.fillSuperview()
        
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.posterAndLargeCoversCellTopPadding),
            bookButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bookButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
}
