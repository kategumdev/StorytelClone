//
//  BookCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/2/23.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BookCollectionViewCell"
    
    enum ItemKind {
        case audiobook
        case ebook
        case audioBookAndEbook
    }
     
    // Created to have custom cornerRadius, because button with UIButton.Configuration doesn't allow it
    private lazy var coverImageContainerView: UIView = {
        let view = UIView()
        view.addSubview(coverImageView)
        view.addSubview(badgeOne)
        view.addSubview(badgeTwo)
        return view
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.bookCoverCornerRadius
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
        
    private let badgeOne = BadgeView()
    private let badgeTwo = BadgeView()
    
    private var buttonTimer: Timer?
    private var isButtonTooLongInHighlightedState = false
    
    private lazy var castViewForButtonAnimation: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var coverImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        
        button.addAction(UIAction(handler: { [weak self] action in
            guard let self = self else { return }

            if self.isButtonTooLongInHighlightedState {
                print("do nothing on touchUpInside")
                self.isButtonTooLongInHighlightedState = false

            } else {
                // Invalidate the timer and perform the touchUpInside action
                self.buttonTimer?.invalidate()
                print("DO smth on touchUpInside")
            }

        }), for: .touchUpInside)
        
        var config = UIButton.Configuration.plain()
        button.configuration = config

        button.configurationUpdateHandler = { [weak self] theButton in
            if theButton.isHighlighted {
                print("button is highlighted")
                
                UIView.animate(withDuration: 0.1, animations: {
                    
                    self?.coverImageContainerView.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                    self?.castViewForButtonAnimation.alpha = 0.4
                    
                })
                let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    if button.isHighlighted {
                        print("Button held for more than 2 seconds, do not perform action")
                        self?.isButtonTooLongInHighlightedState = true
                    }
                }
                self?.buttonTimer = timer
                
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self?.coverImageContainerView.transform = .identity
                    self?.castViewForButtonAnimation.alpha = 0
                })
            }
            
        }
        
        return button
    }()
        
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(coverImageContainerView)
        contentView.addSubview(coverImageButton)
        contentView.addSubview(castViewForButtonAnimation)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("BookCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        castViewForButtonAnimation.frame = contentView.bounds
    }
    
    // MARK: - Helper methods
    func configure(withCoverNumber number: Int, forItemKind itemKind: ItemKind) {
        coverImageView.image = UIImage(named: "image\(number)")

        switch itemKind {
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
    
    private func applyConstraints() {
        
        coverImageContainerView.fillSuperview()
        
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: coverImageContainerView.topAnchor, constant: BadgeView.badgeTopAnchorPoints),
            coverImageView.leadingAnchor.constraint(equalTo: coverImageContainerView.leadingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: coverImageContainerView.bottomAnchor),
            coverImageView.widthAnchor.constraint(equalTo: coverImageContainerView.widthAnchor)

        ])
        
        coverImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverImageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            coverImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageButton.widthAnchor.constraint(equalToConstant: Constants.calculatedSquareCoverSize.width),
            coverImageButton.heightAnchor.constraint(equalToConstant: Constants.calculatedSquareCoverSize.height)
        ])
        
        badgeOne.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badgeOne.trailingAnchor.constraint(equalTo: coverImageButton.trailingAnchor),
            badgeOne.topAnchor.constraint(equalTo: coverImageButton.topAnchor, constant: -BadgeView.badgeTopAnchorPoints),
            badgeOne.widthAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight),
            badgeOne.heightAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight)
        ])
        
        badgeTwo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badgeTwo.trailingAnchor.constraint(equalTo: badgeOne.leadingAnchor, constant: -BadgeView.paddingBetweenBadges),
            badgeTwo.topAnchor.constraint(equalTo: coverImageButton.topAnchor, constant: -BadgeView.badgeTopAnchorPoints),
            badgeTwo.widthAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight),
            badgeTwo.heightAnchor.constraint(equalToConstant: BadgeView.badgeWidthAndHeight)
        ])
    }
    
}
