//
//  LargeBookCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 5/3/23.
//

import UIKit

class LargeBookCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LargeBookCollectionViewCell"
        
    private let bookButton: CellButton = {
        let button = CellButton()
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        button.layer.borderWidth = 0.26
        return button
    }()
    
    private lazy var dimViewForButtonAnimation: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.customBackgroundColor
        return view
    }()
        
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bookButton)
        bookButton.layer.cornerRadius = Constants.largeCoverCornerRadius
        contentView.addSubview(dimViewForButtonAnimation)
        addButtonUpdateHandler()
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
    func configureFor(book: Book, withCallbackForButton callback: @escaping ButtonCallbackClosure) {
        bookButton.book = book
        bookButton.callback = callback
        
        bookButton.configuration?.background.image = book.largeCoverImage
    }
    
    private func addButtonUpdateHandler() {
        bookButton.configurationUpdateHandler = { [weak self] theButton in
            guard let self = self else { return }
            if theButton.isHighlighted {
                print("button is highlighted")
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                    self.dimViewForButtonAnimation.alpha = 0.1
                })
                let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    if self.isHighlighted {
                        print("Button held for more than 2 seconds, do not perform action")
                        self.bookButton.isButtonTooLongInHighlightedState = true
                    }
                }
                self.bookButton.buttonTimer = timer
                
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = .identity
                    self.dimViewForButtonAnimation.alpha = 0
                })
            }
        }
    }
    
    private func applyConstraints() {
        dimViewForButtonAnimation.translatesAutoresizingMaskIntoConstraints = false
        dimViewForButtonAnimation.fillSuperview()
        
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.posterAndLargeCoversCellTopPadding),
            bookButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bookButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
}
