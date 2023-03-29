//
//  PlaySampleButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 29/3/23.
//

import UIKit

class PlaySampleButtonContainer: UIView {
    // MARK: - Static properties
    static let buttonHeight: CGFloat = RoundButtonsStackContainer.buttonWidthAndHeight
    
    // MARK: - Instance properties
    private let button: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.label
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = PlaySampleButtonContainer.buttonHeight / 2
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.attributedTitle = AttributedString("Play a sample")
        buttonConfig.attributedTitle?.font = Utils.navBarTitleFont
        buttonConfig.titleAlignment = .center
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        let image = UIImage(systemName: "play.fill", withConfiguration: symbolConfig)
        buttonConfig.image = image
        buttonConfig.imagePlacement = .leading
        buttonConfig.imagePadding = 12
        button.configuration = buttonConfig
        return button
    }()

    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Utils.customBackgroundColor
        addSubview(button)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            button.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            button.heightAnchor.constraint(equalTo: heightAnchor),
            button.heightAnchor.constraint(equalToConstant: PlaySampleButtonContainer.buttonHeight),
            button.widthAnchor.constraint(equalTo: widthAnchor, constant: -Constants.cvPadding * 2),
//            button.topAnchor.constraint(equalTo: topAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
}
