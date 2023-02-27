//
//  CategoryCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
    
    private var buttonTimer: Timer?
    private var isButtonTooLongInHighlightedState = false
    
    private lazy var castViewForButtonAnimation: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var buttonTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let font = Utils.categoryButtonLabelFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 20)
        label.font = scaledFont
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowOpacity = 0.6// Increase opacity for a stronger shadow effect
        return label
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.bookCoverCornerRadius
        button.clipsToBounds = true
        button.addSubview(buttonTitleLabel)
        
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
                    
                    self?.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
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
        contentView.addSubview(categoryButton)
        contentView.addSubview(castViewForButtonAnimation)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("CategoryCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        castViewForButtonAnimation.frame = contentView.bounds
        categoryButton.frame = contentView.bounds
    }
    
    // MARK: - Helper methods
    func configure(withColor color: UIColor, andTitle title: String) {
        categoryButton.backgroundColor = color
        buttonTitleLabel.text = title
    }
    
    private func applyConstraints() {
        
        buttonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonTitleLabel.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: Constants.cvPadding),
            buttonTitleLabel.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: -(Constants.cvPadding - 4)),
            buttonTitleLabel.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -Constants.cvPadding)
        ])
    }
    
}
