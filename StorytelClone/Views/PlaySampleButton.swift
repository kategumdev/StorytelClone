//
//  PlaySampleButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 29/3/23.
//

import UIKit

class PlaySampleButton: UIButton {
    
    static let buttonHeight: CGFloat = RoundButtonsStackContainer.buttonWidthAndHeight

    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSelf() {
        tintColor = UIColor.label
        layer.borderWidth = 2
        layer.borderColor = UIColor.label.cgColor
        layer.cornerRadius = PlaySampleButton.buttonHeight / 2
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.attributedTitle = AttributedString("Play a sample")
        buttonConfig.attributedTitle?.font = Utils.navBarTitleFont
        buttonConfig.titleAlignment = .center
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        let image = UIImage(systemName: "play.fill", withConfiguration: symbolConfig)
        buttonConfig.image = image
        buttonConfig.imagePlacement = .leading
        buttonConfig.imagePadding = 12
        configuration = buttonConfig
    }
    
}
