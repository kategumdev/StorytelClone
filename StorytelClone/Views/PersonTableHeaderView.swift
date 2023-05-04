//
//  PersonTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 4/5/23.
//

import UIKit

class PersonTableHeaderView: UIView {
    // MARK: - Static property
    static let lighterLabelColor = UIColor.label.withAlphaComponent(0.75)
    
    // MARK: - Instance properties
//    private let roundWidthAndHeight: CGFloat = floor(UIScreen.main.bounds.width / 3)
    private let roundWidthAndHeight: CGFloat = floor(UIScreen.main.bounds.width / 3)
        
    private lazy var roundView: UIView = {
        let view = UIView()
        view.backgroundColor = StorytellerTableHeaderView.roundBackgroundColor
        view.layer.cornerRadius = roundWidthAndHeight / 2
        view.clipsToBounds = true
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = PersonTableHeaderView.lighterLabelColor
        
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageWidthAndHeight = roundWidthAndHeight * 0.55
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: imageWidthAndHeight),
            imageView.widthAnchor.constraint(equalToConstant: imageWidthAndHeight),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -3)
        ])
        return view
    }()
    
    private var greetingLabel: UILabel = {
        let label = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .semibold, size: 19), maximumPointSize: 48, withScaledFont: true, textColor: .label, text: "Hi!")
        label.sizeToFit()
        return label
    }()
    
//    private var greetingLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.text = "Hi!"
//        label.adjustsFontForContentSizeCategory = true
//        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 19)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 48)
//        label.font = scaledFont
//        label.sizeToFit()
//        return label
//    }()

    
    private lazy var getStartedButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.background.backgroundColor = Utils.tintColor
        
        config.attributedTitle = "Get started"
        let font = Utils.navBarTitleFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 45)
        config.attributedTitle?.font = scaledFont
        config.attributedTitle?.foregroundColor = UIColor.white
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 47, bottom: 11, trailing: 47)
        button.configuration = config
        button.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 30, withScaledFont: true, textColor: .label, text: "Already have an account?")
        label.sizeToFit()
        return label
    }()
    
//    private let questionLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 30, withScaledFont: true, textColor: .label, text: "Already have an account?")
    
    
    private lazy var logInButton = createLogInButton()
    
//    private let logInButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .label
//        var config = UIButton.Configuration.plain()
//        config.attributedTitle = "Log in"
//        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 34)
//        config.attributedTitle?.font = scaledFont
//        config.attributedTitle?.foregroundColor = .label
//        config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 32, bottom: 7, trailing: 32)
//        button.configuration = config
//        button.layer.borderColor = UIColor.label.cgColor
//        button.layer.borderWidth = 1
//        button.sizeToFit()
//        button.layer.cornerRadius = button.bounds.height / 2
//        return button
//    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        [roundView, greetingLabel, getStartedButton, questionLabel, logInButton].forEach { stack.addArrangedSubview($0) }
//        [roundView, getStartedButton, questionLabel, logInButton].forEach { stack.addArrangedSubview($0) }

        stack.setCustomSpacing(29, after: getStartedButton)
        stack.setCustomSpacing(11, after: questionLabel)
        return stack
    }()
    
    private lazy var container: UIView = {
        let view = UIView()
        view.addSubview(stack)
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stack)
        applyConstraints()
        stack.backgroundColor = .green
        greetingLabel.backgroundColor = .yellow
        questionLabel.backgroundColor = .blue
        backgroundColor = .magenta
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        logInButton.layer.cornerRadius = logInButton.bounds.height / 2
//
//    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            logInButton.layer.borderColor = UIColor.label.cgColor
        }
        
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            let button = createLogInButton()
            logInButton.layer.cornerRadius = button.bounds.height / 2
        }
        
    }
    
    // MARK: - Instance methods

    
    // MARK: - Helper methods
    private func createLogInButton() -> UIButton {
        let button = UIButton()
        button.tintColor = .label
        var config = UIButton.Configuration.plain()
        config.attributedTitle = "Log in"
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 34)
        config.attributedTitle?.font = scaledFont
        config.attributedTitle?.foregroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 32, bottom: 7, trailing: 32)
        button.configuration = config
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.sizeToFit()
        button.layer.cornerRadius = button.bounds.height / 2
        return button
    }

    private func applyConstraints() {
        roundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundView.widthAnchor.constraint(equalToConstant: roundWidthAndHeight),
            roundView.heightAnchor.constraint(equalToConstant: roundWidthAndHeight)
        ])
        
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),
//            stack.centerXAnchor.constraint(equalTo: centerXAnchor)
//        ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        translatesAutoresizingMaskIntoConstraints = false
        // Avoid constraint's conflict when header is added to table view
        for constraint in constraints {
            constraint.priority = UILayoutPriority(750)
        }
    }
}

