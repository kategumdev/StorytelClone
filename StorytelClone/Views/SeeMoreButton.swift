//
//  SeeMoreButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 28/3/23.
//

import UIKit

class SeeMoreButton: UIButton {
    
    // MARK: - Instance properties
    let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
    static let buttonHeight: CGFloat = 110
    
    private lazy var buttonConfig: UIButton.Configuration = {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.attributedTitle = AttributedString("See more")
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
//        gradientLayer.locations = [0, 0.75]
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
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        print("layoutSubviews, button size: \(bounds.size)")
        if !gradientIsAdded {
            addGradient()
//            print("adding gradient")
            gradientIsAdded = true
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            
            if let gradientLayer = self.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
                    gradientLayer.colors = gradientColors
                }
        }
    }
    
//    func toggleButtonText() {
////        configuration?.attributedTitle?.font = font
//        if configuration?.attributedTitle == AttributedString("See more") {
//            print("is see more")
//            configuration?.attributedTitle = AttributedString("See less")
//            configuration?.attributedTitle?.font = font
//        } else {
//            print("is see less")
//            configuration?.attributedTitle = AttributedString("See more")
//            configuration?.attributedTitle?.font = font
//        }
//    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        self.tintColor = .label
        var config = buttonConfig
        
        // Position button text y-centered in the lower half of the button height
        let bottomInset = ((SeeMoreButton.buttonHeight / 2) - intrinsicButtonHeight) / 2
        print("intrinsicButtonHeight: \(intrinsicButtonHeight), bottomInset: \(bottomInset)")
        let topInset = SeeMoreButton.buttonHeight - (intrinsicButtonHeight + bottomInset)
        config.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: bottomInset, trailing: 0)
               
        self.configuration = config
    }
    
    func addGradient() {
        self.layer.addSublayer(gradientLayer)
        // Ensure that button text and symbol image show above gradient layer
        gradientLayer.zPosition = -1
    }

}
