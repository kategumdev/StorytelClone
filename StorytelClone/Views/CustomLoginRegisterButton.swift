//
//  LoginRegisterButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 30/6/23.
//

import UIKit

protocol LoginRegisterButton: UIButton {
    var kind: LoginRegisterButtonKind { get }
}

enum LoginRegisterButtonKind: String {
    // Raw value is button text
    case appleLogin = "Sign in with Apple"
    case appleRegister = "Continue with Apple"
    
    case emailLogin = "Log in with E-mail"
    case emailRegister = "Create with E-mail"
            
    var buttonImage: UIImage? {
        var imageName: String
        switch self {
        case .appleLogin, .appleRegister: imageName = "apple.logo"
        case .emailLogin, .emailRegister: imageName = "envelope.circle.fill"
        }
        let image = UIImage(systemName: imageName)
        return image
    }
}

class CustomLoginRegisterButton: UIButton, LoginRegisterButton {
    
    // MARK: - Instance properties
    let kind: LoginRegisterButtonKind
    private let buttonHeight: CGFloat
    private let borderColor: CGColor
    private let imageSize: CGSize
    
    private let customLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(textStyle: .callout, weight: .semibold, maxPointSize: 40)
        let label = UILabel.createLabelWith(font: scaledFont, text: "Continue with Apple")
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var firstTime = true
    
    // MARK: - Initializers
    init(kind: LoginRegisterButtonKind, buttonHeight: CGFloat = 52, borderColor: CGColor = UIColor.systemGray3.cgColor, imageSize: CGSize = CGSize(width: 30, height: 30)) {
        self.kind = kind
        self.buttonHeight = buttonHeight
        self.borderColor = borderColor
        self.imageSize = imageSize
        super.init(frame: .zero)
        tintColor = .label
        layer.borderWidth = 3
        layer.borderColor = borderColor
        layer.cornerRadius = buttonHeight / 2

        customImageView.image = kind.buttonImage
        customLabel.text = kind.rawValue
        addSubview(customLabel)
        addSubview(customImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = borderColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if firstTime {
            firstTime = false
            applyConstraints()
        }
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        guard let superview = superview else { return }
        let superviewWidth = superview.bounds.width
        widthAnchor.constraint(equalToConstant: superviewWidth).isActive = true
            
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        let leadingTrailingPadding: CGFloat = 10
        NSLayoutConstraint.activate([
            customImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            customImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingTrailingPadding),
            customImageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            customImageView.heightAnchor.constraint(equalToConstant: imageSize.height)
        ])
        
        customLabel.translatesAutoresizingMaskIntoConstraints = false
                
        let imageLabelPadding: CGFloat = 4
        let widthConstant = (imageSize.width + leadingTrailingPadding + imageLabelPadding) * 2
        let width = superviewWidth - widthConstant
        NSLayoutConstraint.activate([
            customLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            customLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            customLabel.widthAnchor.constraint(equalToConstant: width)
        ])
    }
    
}
