//
//  SeeMoreButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 28/3/23.
//

import UIKit

// For SeeMoreOverviewButton and showAllTagsButton in BookViewController
class SeeMoreButton: UIButton {
    // MARK: - Instance properties
    let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
    let seeMoreOverviewButtonHeight: CGFloat = 110
    
    lazy var showAllTagsButtonHeight: CGFloat = {
        let topInset = ((seeMoreOverviewButtonHeight / 2) - intrinsicButtonHeight) / 2
        let height = intrinsicButtonHeight + topInset
        return height
    }()
    
    private lazy var buttonConfig: UIButton.Configuration = {
        var buttonConfig = UIButton.Configuration.plain()
        let text = forOverview == true ? "See more" : "Show all tags"
        buttonConfig.attributedTitle = AttributedString(text)
        buttonConfig.attributedTitle?.font = font
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
    
    private lazy var intrinsicButtonHeight: CGFloat = {
        let button = UIButton()
        var config = buttonConfig
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
        button.sizeToFit()
        let height = button.bounds.size.height
        return height
    }()
    
    private var currentTransform = CGAffineTransform.identity
    
    // true if initializing seeMoreOverviewButton, false if initializing showAllTagsButton in BookViewController
    private let forOverview: Bool
    
    // MARK: - View life cycle
    init(forOverview: Bool) {
        self.forOverview = forOverview
        super.init(frame: .zero)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !gradientIsAdded && forOverview {
            addGradient()
            gradientIsAdded = true
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard forOverview else { return }
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            
            if let gradientLayer = self.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
                    gradientLayer.colors = gradientColors
                }
        }
    }
    
    // MARK: - Helper methods
    func setButtonTextTo(text: String) {
        configuration?.attributedTitle = AttributedString(text)
        configuration?.attributedTitle?.font = font
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

//            imageView.transform = self.currentTransform
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            imageView.transform = newTransform
        }
        currentTransform = newTransform
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        self.tintColor = .label
        var config = buttonConfig
        
        if forOverview {
            // Position button text y-centered in the lower half of the button height
            let bottomInset = ((seeMoreOverviewButtonHeight / 2) - intrinsicButtonHeight) / 2
            let topInset = seeMoreOverviewButtonHeight - (intrinsicButtonHeight + bottomInset)
            config.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: bottomInset, trailing: 0)
        } else {
            // Position button text at the bottom of the button
            let topInset = showAllTagsButtonHeight - intrinsicButtonHeight
            config.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: 0, trailing: 0)
            backgroundColor = Utils.customBackgroundColor
        }
               
        self.configuration = config
    }
    
    private func addGradient() {
        self.layer.addSublayer(gradientLayer)
        // Ensure that button text and symbol image show above gradient layer
        gradientLayer.zPosition = -1
    }

}
