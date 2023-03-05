//
//  BookCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/2/23.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BookCollectionViewCell"
 
    private var book: Book?
    
    // Closure to tell owning controller to push new vc
    var callbackClosure: BookButtonCallbackClosure = {_ in}
        
    private let badgeOne = BadgeView()
    private let badgeTwo = BadgeView()
    
    private var buttonTimer: Timer?
    private var isButtonTooLongInHighlightedState = false
    
    private lazy var castViewForButtonAnimation: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.customBackgroundColor
        return view
    }()
    
    private lazy var coverImageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.bookCoverCornerRadius
        button.clipsToBounds = true
        
        button.addAction(UIAction(handler: { [weak self] action in
            guard let self = self else { return }

            if self.isButtonTooLongInHighlightedState {
                print("do nothing on touchUpInside")
                self.isButtonTooLongInHighlightedState = false

            } else {
                // Invalidate the timer and perform the touchUpInside action
                self.buttonTimer?.invalidate()
                print("DO smth on touchUpInside")
                
                // Closure passed to this cell from TableViewCellWithCollection which got closure from owning controller
                guard let book = self.book else { return }
                self.callbackClosure(book)
            }

        }), for: .touchUpInside)
        
        var config = UIButton.Configuration.plain()
        config.background.imageContentMode = .scaleAspectFill
        
        // This prevents from dynamic cornerRadius and button.layer.cornerRadius works
        config.background.cornerRadius = 0
        
        button.configuration = config

        button.configurationUpdateHandler = { [weak self] theButton in
            if theButton.isHighlighted {
                print("button is highlighted")
                
                UIView.animate(withDuration: 0.1, animations: {
                    
                    self?.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                    self?.castViewForButtonAnimation.alpha = 0.1
                    
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
                    
                    self?.transform = .identity
                    self?.castViewForButtonAnimation.alpha = 0
                    
                })
            }
            
        }
        
        return button
    }()
        
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(coverImageButton)
        contentView.addSubview(badgeOne)
        contentView.addSubview(badgeTwo)
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
    func configureFor(book: Book) {
        self.book = book
        coverImageButton.configuration?.background.image = book.coverImage
  
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
    
    private func applyConstraints() {

        coverImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverImageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            coverImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageButton.widthAnchor.constraint(equalToConstant: Utils.calculatedSquareCoverSize.width),
            coverImageButton.heightAnchor.constraint(equalToConstant: Utils.calculatedSquareCoverSize.height)
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
