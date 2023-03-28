//
//  SeeMoreView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/3/23.
//

import UIKit

class SeeMoreView: UIView {
    
    static let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
    
    let viewHeight: CGFloat = 110
    
    private let seeMoreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.attributedTitle = AttributedString("See more")
        buttonConfig.attributedTitle?.font = SeeMoreView.font
//        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: bottomPadding, leading: 0, bottom: bottomPadding, trailing: 0)
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        buttonConfig.titleAlignment = .center
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
        let image = UIImage(systemName: "chevron.down", withConfiguration: symbolConfig)
        buttonConfig.image = image
        buttonConfig.imagePlacement = .trailing
        buttonConfig.imagePadding = 4
        button.configuration = buttonConfig
        
//        button.sizeToFit()
//        button.backgroundColor = Utils.customBackgroundColor
//        button.backgroundColor = .magenta

        return button
    }()
    
    private lazy var intrinsicButtonHeight: CGFloat = {
        seeMoreButton.sizeToFit()
        let height = seeMoreButton.bounds.height
        return height
    }()
    
//    private let dimView: UIView = {
//        let view = UIView()
//        return view
//    }()
    
    private let dimView = UIView()
    private var gradientIsAdded = false
    
    private var gradientColors: [CGColor] {
        let colors = [Utils.customBackgroundColor!.withAlphaComponent(1).cgColor,      Utils.customBackgroundColor!.withAlphaComponent(0).cgColor]
        return colors
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(dimView)
        addSubview(seeMoreButton)
//        backgroundColor = .green
//        backgroundColor = Utils.customBackgroundColor
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        print("layoutSubviews, dimView size: \(dimView.bounds.size)")
        
        if !gradientIsAdded {
            addGradient()
            print("adding gradient")
            gradientIsAdded = true
        }

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            
            if let gradientLayer = dimView.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
                    gradientLayer.colors = gradientColors
                }
        }
    }
    
    private func applyConstraints() {
        dimView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: topAnchor),
            dimView.heightAnchor.constraint(equalToConstant: viewHeight / 2),
            dimView.widthAnchor.constraint(equalTo: widthAnchor),
            dimView.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
        
        // Position button y- and x-centered in the lower part of seeMoreView
        let intrinsicButtonHeight = intrinsicButtonHeight
        let bottomPadding = ((viewHeight / 2) - intrinsicButtonHeight) / 2
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeMoreButton.widthAnchor.constraint(equalTo: widthAnchor),
//            seeMoreButton.heightAnchor.constraint(equalToConstant: viewHeight / 2),
            seeMoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            seeMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding)
        ])
        
        
        
        
//        // Position button y- and x-centered in the lower part of seeMoreView
//        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            seeMoreButton.widthAnchor.constraint(equalTo: widthAnchor),
//            seeMoreButton.heightAnchor.constraint(equalToConstant: viewHeight / 2),
//            seeMoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//        ])
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = dimView.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        dimView.layer.addSublayer(gradientLayer)
    }
    
}
