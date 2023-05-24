//
//  SeeMoreButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 28/3/23.
//

import UIKit

class SeeMoreButton: UIButton {
    
    enum ButtonKind {
        case forOverview
        case forTags
    }
    
    // MARK: - Instance properties
    private let buttonKind: ButtonKind
    private let seeOverviewButtonHeight: CGFloat = 110
    private let scaledFont = UIFont.createScaledFontWith(textStyle: .footnote, weight: .semibold, maxPointSize: 34)
    
    lazy var heightConstant: CGFloat = {
        switch buttonKind {
        case .forOverview: return seeOverviewButtonHeight
        case .forTags:
            let topInset = ((seeOverviewButtonHeight / 2) - intrinsicButtonHeight) / 2
            let height = intrinsicButtonHeight + topInset
            return height
        }
    }()
    
    private lazy var intrinsicButtonHeight: CGFloat = {
        let button = UIButton()
        var config = buttonConfig
        config.contentInsets = .zero
        button.configuration = config
        button.sizeToFit()
        let height = button.bounds.height
        return height
    }()
    
    private lazy var buttonConfig: UIButton.Configuration = {
        var buttonConfig = UIButton.Configuration.plain()
        let text = buttonKind == .forOverview ? "See more" : "Show all tags"
        buttonConfig.attributedTitle = AttributedString(text)
        buttonConfig.attributedTitle?.font = scaledFont
        buttonConfig.titleAlignment = .center
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
        let image = UIImage(systemName: "chevron.down", withConfiguration: symbolConfig)
        buttonConfig.image = image
        buttonConfig.imagePlacement = .trailing
        buttonConfig.imagePadding = 4
        return buttonConfig
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = [0, 0.5]
        gradientLayer.frame = self.bounds
        return gradientLayer
    }()
    
    private var gradientIsAdded = false

    private var gradientColors: [CGColor] {
        let colors = [UIColor.customBackgroundColor!.withAlphaComponent(0).cgColor,      UIColor.customBackgroundColor!.withAlphaComponent(1).cgColor]
        return colors
    }
    
    private var currentTransform = CGAffineTransform.identity
    
    // MARK: - Initializers
    init(buttonKind: ButtonKind) {
        self.buttonKind = buttonKind
        super.init(frame: .zero)
        configureSelf()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        if !gradientIsAdded && buttonKind == .forOverview {
            addGradient()
            gradientIsAdded = true
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard buttonKind == .forOverview else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            gradientLayer.colors = gradientColors
        }
    }
    
    // MARK: - Instance methods
    func updateButtonTextWith(newText: String) {
        configuration?.attributedTitle = AttributedString(newText)
        configuration?.attributedTitle?.font = scaledFont
    }
    
    func rotateImage() {
        guard let imageView = imageView else { return }
        // Rotate the image view 180 degrees
        var newTransform: CGAffineTransform
        if currentTransform == CGAffineTransform.identity {
            newTransform = CGAffineTransform(rotationAngle: -CGFloat.pi)
        } else {
            newTransform = CGAffineTransform.identity
        }

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            imageView.transform = newTransform
        }
        currentTransform = newTransform
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        self.tintColor = .label
        var config = buttonConfig
        
        switch buttonKind {
        case .forOverview:
            // Position button text y-centered in the lower half of the button height
            let bottomInset = ((seeOverviewButtonHeight / 2) - intrinsicButtonHeight) / 2
            let topInset = seeOverviewButtonHeight - (intrinsicButtonHeight + bottomInset)
            config.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: bottomInset, trailing: 0)
            
        case .forTags:
            // Position button text at the bottom of the button
            let topInset = heightConstant - intrinsicButtonHeight
            config.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: 0, trailing: 0)
            backgroundColor = UIColor.customBackgroundColor
        }
        self.configuration = config
    }
    
    private func addGradient() {
        self.layer.addSublayer(gradientLayer)
        // Ensure that button text and symbol image show above gradient layer
        gradientLayer.zPosition = -1
    }
    
}
