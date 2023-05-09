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
    
//    private let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//    let fontMaximumPointSize: CGFloat = 40
    
    private let seeOverviewButtonHeight: CGFloat = 110
    
//    lazy var heightConstant: CGFloat = {
//        switch buttonKind {
//        case .forOverview: return seeOverviewButtonHeight
//        case .forTags:
//            let topInset = ((seeOverviewButtonHeight / 2) - intrinsicButtonHeight) / 2
//            let height = intrinsicButtonHeight + topInset
//            return height
//        }
//    }()
    
//    lazy var heightConstant: CGFloat = {
//        switch buttonKind {
//        case .forOverview: return seeOverviewButtonHeight
//        case .forTags:
//            let intrinsicButtonHeight = self.getIntrinsicButtonHeight()
//            let topInset = ((seeOverviewButtonHeight / 2) - intrinsicButtonHeight) / 2
//            let height = intrinsicButtonHeight + topInset
//            return height
//        }
//    }()
    
    lazy var heightConstant: CGFloat = getHeightConstant()
    
//    lazy var showAllTagsButtonHeight: CGFloat = {
//        let topInset = ((seeOverviewButtonHeight / 2) - intrinsicButtonHeight) / 2
//        let height = intrinsicButtonHeight + topInset
//        return height
//    }()
    
    private lazy var buttonConfig: UIButton.Configuration = {
        var buttonConfig = UIButton.Configuration.plain()
        let text = buttonKind == .forOverview ? "See more" : "Show all tags"
        buttonConfig.attributedTitle = AttributedString(text)
//        buttonConfig.attributedTitle = AttributedString(buttonText)
        buttonConfig.attributedTitle?.font = self.getScaledFont()
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: fontMaximumPointSize)
//        buttonConfig.attributedTitle?.font = scaledFont
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
        let colors = [Utils.customBackgroundColor!.withAlphaComponent(0).cgColor,      Utils.customBackgroundColor!.withAlphaComponent(1).cgColor]
        return colors
    }
    
//    private lazy var intrinsicButtonHeight: CGFloat = {
//        let button = UIButton()
//        var config = buttonConfig
////        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//        config.contentInsets = .zero
//        button.configuration = config
//        button.sizeToFit()
////        let height = button.bounds.size.height
//        let height = button.bounds.height
//        return height
//    }()
    
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
        
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            buttonConfig.attributedTitle?.font = getScaledFont()
            heightConstant = getHeightConstant()
            layoutIfNeeded()
        }
        
        guard buttonKind == .forOverview else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            gradientLayer.colors = gradientColors
        }
        
    }
    
    // MARK: - Instance methods
    func setButtonTextTo(text: String) {
        configuration?.attributedTitle = AttributedString(text)
        configuration?.attributedTitle?.font = getScaledFont()
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: fontMaximumPointSize)
//        configuration?.attributedTitle?.font = scaledFont
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
        let intrinsicButtonHeight = self.getIntrinsicButtonHeight()
        
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
//            backgroundColor = Utils.customBackgroundColor
            backgroundColor = .orange
        }
        
//        if buttonKind == .forOverview {
//            // Position button text y-centered in the lower half of the button height
//            let bottomInset = ((seeOverviewButtonHeight / 2) - intrinsicButtonHeight) / 2
//            let topInset = seeOverviewButtonHeight - (intrinsicButtonHeight + bottomInset)
//            config.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: bottomInset, trailing: 0)
//        } else {
//            // Position button text at the bottom of the button
//            let topInset = heightConstant - intrinsicButtonHeight
//            config.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: 0, trailing: 0)
//            backgroundColor = Utils.customBackgroundColor
//        }
//
        self.configuration = config
    }
    
    private func getScaledFont() -> UIFont {
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 40)
        return scaledFont
    }
    
    private func getIntrinsicButtonHeight() -> CGFloat {
        let button = UIButton()
        var config = buttonConfig
        config.contentInsets = .zero
        button.configuration = config
        button.sizeToFit()
        let height = button.bounds.height
        return height
    }
    
    private func getHeightConstant() -> CGFloat {
        switch buttonKind {
        case .forOverview: return seeOverviewButtonHeight
        case .forTags:
            let intrinsicButtonHeight = self.getIntrinsicButtonHeight()
            let topInset = ((seeOverviewButtonHeight / 2) - intrinsicButtonHeight) / 2
            let height = intrinsicButtonHeight + topInset
            return height
        }
    }
    
    private func addGradient() {
        self.layer.addSublayer(gradientLayer)
        // Ensure that button text and symbol image show above gradient layer
        gradientLayer.zPosition = -1
    }

}
