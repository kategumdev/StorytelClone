//
//  PlaySampleButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 29/3/23.
//

import UIKit

class PlaySampleButtonContainer: UIView {
    // MARK: - Static properties
    static let buttonHeight: CGFloat = RoundButtonsStackContainer.roundWidth
    
    // MARK: - Instance properties
    private let button: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.label
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = PlaySampleButtonContainer.buttonHeight / 2
        
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.numberOfLines = 1
        
        let scaledFont = UIFontMetrics.default.scaledFont(for: Utils.navBarTitleFont, maximumPointSize: 40)
        button.titleLabel?.font = scaledFont
        
        let title = NSAttributedString(string: "Play a beautiful sample")
        button.setAttributedTitle(title, for: .normal)
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        let image = UIImage(systemName: "play.fill", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
                
        // Adjust the padding between the title and image
//        let padding: CGFloat = 10.0
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: -padding)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: padding)
        
        button.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        guard let label = button.titleLabel, let imageView = button.imageView else { return button }
        let constraint = label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12)
        constraint.priority = .defaultHigh
        constraint.isActive = true
//        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12).isActive = true
        return button
    }()
    
//    private let button: UIButton = {
//        let button = UIButton()
//        button.tintColor = UIColor.label
//        button.layer.borderWidth = 2
//        button.layer.borderColor = UIColor.label.cgColor
//        button.layer.cornerRadius = PlaySampleButtonContainer.buttonHeight / 2
//
////        button.titleLabel?.lineBreakMode = .byTruncatingTail
////        button.titleLabel?.numberOfLines = 1
//
//        var buttonConfig = UIButton.Configuration.plain()
//        buttonConfig.attributedTitle = AttributedString("Play a beautiful sample")
//
////        buttonConfig.attributedTitle?.paragraphStyle?.lineBreakMode = .byTruncatingMiddle
//
////        // Customize the title attributes
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineBreakMode = .byTruncatingTail
//        paragraphStyle.lineBreakStrategy
////
////
//        let titleAttributes: [NSAttributedString.Key: Any] = [
//            .paragraphStyle: paragraphStyle,
//        ]
//
//        let attributedString = NSMutableAttributedString(
//            string: "Your long text here",
//            attributes: titleAttributes
//        )
//
//        button.setAttributedTitle(attributedString, for: .normal)
//
////        buttonConfig.attributedTitle?.setAttributes(titleAttributes)
//
//
////        button.configuration?.attributedTitle = NSAttributedString(
////            string: "Your long text here",
////            attributes: titleAttributes
////        )
//
//        buttonConfig.attributedTitle?.font = Utils.navBarTitleFont
//        buttonConfig.titleAlignment = .center
////        buttonConfig.contentInsets = .zero
//        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
//        let image = UIImage(systemName: "play.fill", withConfiguration: symbolConfig)
//        buttonConfig.image = image
//        buttonConfig.imagePlacement = .leading
//        buttonConfig.imagePadding = 12
//        button.configuration = buttonConfig
//        // Limit the number of lines to 1
//        button.titleLabel?.numberOfLines = 1
//        return button
//    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Utils.customBackgroundColor
        addSubview(button)
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
        
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            let scaledFont = UIFontMetrics.default.scaledFont(for: Utils.navBarTitleFont, maximumPointSize: 40)
            button.titleLabel?.font = scaledFont
//            button.configuration?.attributedTitle?.font = scaledFont
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
    }
    
}
