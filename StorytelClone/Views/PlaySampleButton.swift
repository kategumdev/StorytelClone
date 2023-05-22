//
//  PlaySampleButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 29/3/23.
//

import UIKit

class PlaySampleButtonContainer: UIView {
    // MARK: - Static properties
    static let buttonHeight: CGFloat = RoundButtonsStack.roundWidth
    
    // MARK: - Instance properties
    private let button: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.label
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = PlaySampleButtonContainer.buttonHeight / 2
        return button
    }()
    
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 19, weight: .semibold)
        let image = UIImage(systemName: "play.fill", withConfiguration: symbolConfig)
        imageView.image = image
        return imageView
    }()

    private let customTitleLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(textStyle: .callout, weight: .semibold, basePointSize: 16, maximumPointSize: 40)
        let label = UILabel.createLabelWith(font: scaledFont, text: "Play a sample")
        return label
    }()

    private lazy var horzStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.addArrangedSubview(customImageView)
        stack.addArrangedSubview(customTitleLabel)
        return stack
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Utils.customBackgroundColor
        addSubview(button)
        button.addSubview(horzStack)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
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
            button.heightAnchor.constraint(equalToConstant: PlaySampleButtonContainer.buttonHeight),
            button.widthAnchor.constraint(equalTo: widthAnchor, constant: -Constants.commonHorzPadding * 2),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        horzStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horzStack.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            horzStack.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            horzStack.leadingAnchor.constraint(greaterThanOrEqualTo: button.leadingAnchor, constant: 10),
            horzStack.trailingAnchor.constraint(lessThanOrEqualTo: button.trailingAnchor, constant: -10)
        ])
    }
    
}
