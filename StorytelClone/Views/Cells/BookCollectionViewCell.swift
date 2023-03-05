//
//  BookCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/2/23.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BookCollectionViewCell"
        
    private let badgeOne = BadgeView()
    private let badgeTwo = BadgeView()
    
    private let bookButton = CellButton()
    
    private lazy var dimViewForButtonAnimation: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.customBackgroundColor
        return view
    }()
        
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bookButton)
        contentView.addSubview(badgeOne)
        contentView.addSubview(badgeTwo)
        contentView.addSubview(dimViewForButtonAnimation)
        addButtonUpdateHandler()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("BookCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    // MARK: - Helper methods
    func configureFor(book: Book, withCallbackForButton callback: @escaping BookButtonCallbackClosure) {
        bookButton.book = book
        bookButton.callbackClosure = callback
        
        // For badges to transform, self has to be transformed instead of default DimViewAnimationButton behaviour
//        bookButton.viewToTransform = self
  
        let bookKind  = book.bookKind
        switch bookKind {
        case .audiobook:
            badgeOne.badgeImageView.image = UIImage(systemName: "headphones")
            badgeTwo.isHidden = true
        case .ebook:
            badgeOne.badgeImageView.image = UIImage(named: "glasses")
            badgeTwo.isHidden = true
        case .audioBookAndEbook:
            badgeOne.badgeImageView.image = UIImage(systemName: "headphones")
            badgeTwo.isHidden = false
            badgeTwo.badgeImageView.image = UIImage(named: "glasses")
        }
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
