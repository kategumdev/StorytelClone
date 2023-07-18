//
//  CustomLoginRegisterButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 30/6/23.
//

import UIKit

class CustomLoginRegisterButton: UIButton, LoginRegisterButton {
    let kind: LoginRegisterButtonKind
    private let buttonHeight: CGFloat = 52
    private let imageSize: CGSize = CGSize(width: 30, height: 30)
    private var borderColor: CGColor? {
        return UIColor.systemGray3.cgColor
    }
    
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let customLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(
            textStyle: .callout,
            weight: .semibold,
            maxPointSize: 40)
        let label = UILabel.createLabelWith(font: scaledFont, text: "Continue with Apple")
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    private var isLayoutSubviewsTriggeredFirstTime = true
    
    var didTapCallback: LoginRegisterBtnDidTapCallback = {_ in}
    
    // MARK: - Initializers
    init(kind: LoginRegisterButtonKind) {
        self.kind = kind
        super.init(frame: .zero)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = borderColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isLayoutSubviewsTriggeredFirstTime {
            isLayoutSubviewsTriggeredFirstTime = false
            applyConstraints()
        }
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        setupUI()
        addButtonAction()
    }
    
    private func setupUI() {
        tintColor = .label
        layer.borderWidth = 2
        layer.borderColor = borderColor
        layer.cornerRadius = buttonHeight / 2
        
        customImageView.image = kind.buttonImage
        customLabel.text = kind.rawValue
        addSubview(customLabel)
        addSubview(customImageView)
    }
    
    private func addButtonAction() {
        addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            guard self.kind == .emailLogin || self.kind == .emailRegister else { return }
            self.didTapCallback(self.kind)
        }), for: .touchUpInside)
    }
    
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
            customImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: leadingTrailingPadding),
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
