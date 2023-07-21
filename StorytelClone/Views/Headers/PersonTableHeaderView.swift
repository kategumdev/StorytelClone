//
//  PersonTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 4/4/23.
//

import UIKit

class PersonTableHeaderView: UIView {
    enum HeaderKind: Equatable {
        case forStoryteller(storyteller: Storyteller, superviewWidth: CGFloat)
        case forLoggedOutProfile
        case forLoggedInProfile
    }
    
    // MARK: - Instance properties
    private let lighterLabelColor = UIColor.label.withAlphaComponent(0.75)
    private let roundWidthAndHeight: CGFloat = floor(UIScreen.main.bounds.width / 3)
    private let stackHorzPadding: CGFloat = 20
    private let kind: HeaderKind
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    private lazy var roundLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(
            textStyle: .largeTitle,
            weight: .semibold,
            basePointSize: 35)
        let label = UILabel.createLabelWith(font: scaledFont)
        label.textAlignment = .center
        label.backgroundColor = UIColor.systemGray5
        label.layer.cornerRadius = roundWidthAndHeight / 2
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var storytellerNameLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(
            textStyle: .headline,
            weight: .semibold,
            maxPointSize: 48)
        let label = UILabel.createLabelWith(font: scaledFont, numberOfLines: 2)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var storytellerKindLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(
            textStyle: .footnote,
            weight: .regular,
            maxPointSize: 38)
        let label = UILabel.createLabelWith(font: scaledFont)
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.tintColor =
        UIColor.systemGray4.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.background.backgroundColor = .systemGray2
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let image = UIImage(systemName: "plus", withConfiguration: symbolConfig)
        config.image = image
        config.imagePadding = 10
        
        config.attributedTitle = "Follow"
        let scaledFont = UIFont.customCalloutSemibold
        config.attributedTitle?.font = scaledFont
        config.attributedTitle?.foregroundColor = UIColor.customBackgroundLight
        
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 13,
            leading: 44,
            bottom: 13,
            trailing: 44)
        button.configuration = config
        return button
    }()
    
    private lazy var numberOfFollowersStack: UIStackView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = lighterLabelColor
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let image = UIImage(systemName: "person.2.fill", withConfiguration: symbolConfig)
        imageView.image = image
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 7
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(numberOfFollowersLabel)
        
        /* Avoid constraints' ambiguity, if label text is long (i.e. translation and/or large
         content size category) and wraps to the next line */
        numberOfFollowersLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return stack
    }()
    
    private lazy var numberOfFollowersLabel = UILabel.createLabelWith(
        font: UIFont.customFootnoteRegular,
        textColor: lighterLabelColor)
    
    private lazy var greetingsLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(
            textStyle: .title3,
            weight: .semibold,
            basePointSize: 19,
            maxPointSize: 48)
        let label = UILabel.createLabelWith(font: scaledFont, text: "Hi!")
        return label
    }()
    
    private lazy var getStartedButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.background.backgroundColor = UIColor.customTintColor
        
        config.attributedTitle = "Get started"
        let scaledFont = UIFont.customCalloutSemibold
        config.attributedTitle?.font = scaledFont
        config.attributedTitle?.foregroundColor = UIColor.white
        
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 11,
            leading: 47,
            bottom: 11,
            trailing: 47)
        button.configuration = config
        button.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private lazy var questionLabel = UILabel.createLabelWith(
        font: UIFont.customFootnoteRegular,
        text: "Already have an account?")
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        var config = UIButton.Configuration.plain()
        config.attributedTitle = "Log in"
        let scaledFont = UIFont.createScaledFontWith(
            textStyle: .footnote,
            weight: .semibold,
            maxPointSize: 34)
        config.attributedTitle?.font = scaledFont
        config.attributedTitle?.foregroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 7,
            leading: 32,
            bottom: 7,
            trailing: 32)
        button.configuration = config
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.sizeToFit()
        button.layer.cornerRadius = button.bounds.height / 2
        return button
    }()
    
    var getStartedButtonDidTapCallback: () -> () = {}
    var logInButtonDidTapCallback: () -> () = {}
    
    // MARK: - Initializers
    init(kind: HeaderKind) {
        self.kind = kind
        super.init(frame: .zero)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if kind == .forLoggedOutProfile {
                logInButton.layer.borderColor = UIColor.label.cgColor
            }
        }
    }
}

// MARK: - Helper methods
extension PersonTableHeaderView {
    private func configureSelf() {
        switch kind {
        case .forStoryteller(let storyteller, let superviewWidth):
            configureFor(storyteller: storyteller, superviewWidth: superviewWidth)
        case .forLoggedOutProfile:
            configureForLoggedOutProfile()
        case .forLoggedInProfile:
            configureForLoggedInProfile()
        }
        
        addSubview(stack)
        applyConstraints()
    }
    
    private func configureFor(storyteller: Storyteller, superviewWidth: CGFloat) {
        // Configure stack itself
        stack.spacing = 20
        let views = [
            roundLabel,
            storytellerNameLabel,
            storytellerKindLabel,
            followButton,
            numberOfFollowersStack
        ]
        views.forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(7, after: storytellerNameLabel)
        
        // Configure stack subviews
        storytellerKindLabel.text = storyteller.titleKind.rawValue
        
        storytellerNameLabel.text = storyteller.name
        storytellerNameLabel.preferredMaxLayoutWidth = superviewWidth - stackHorzPadding
        
        configureRoundLabelWithLettersFrom(name: storyteller.name)
        
        let numberOfFollowers = storyteller.numberOfFollowers.shorted()
        numberOfFollowersLabel.text = "\(numberOfFollowers) Followers"
    }
    
    private func configureForLoggedOutProfile() {
        // Configure stack itself
        stack.spacing = 16
        let views = [
            roundLabel,
            greetingsLabel,
            getStartedButton,
            questionLabel,
            logInButton
        ]
        views.forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(29, after: getStartedButton)
        stack.setCustomSpacing(11, after: questionLabel)
        
        // Configure stack subviews
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = lighterLabelColor
        
        roundLabel.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageWidthAndHeight = roundWidthAndHeight * 0.55
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: imageWidthAndHeight),
            imageView.widthAnchor.constraint(equalToConstant: imageWidthAndHeight),
            imageView.centerXAnchor.constraint(equalTo: roundLabel.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: roundLabel.centerYAnchor, constant: -3)
        ])
        addGetStartedButtonAction()
        addLogInButtonAction()
    }
    
    private func configureForLoggedInProfile() {
        // Configure stack itself
        stack.spacing = 16
        let views = [roundLabel, greetingsLabel]
        views.forEach { stack.addArrangedSubview($0) }
        
        // Configure stack subviews
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = lighterLabelColor
        
        roundLabel.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageWidthAndHeight = roundWidthAndHeight * 0.55
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: imageWidthAndHeight),
            imageView.widthAnchor.constraint(equalToConstant: imageWidthAndHeight),
            imageView.centerXAnchor.constraint(equalTo: roundLabel.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: roundLabel.centerYAnchor, constant: -3)
        ])
    }
    
    private func configureRoundLabelWithLettersFrom(name: String) {
        let originalString = name
        let components = originalString.components(separatedBy: " ")
        var letters = ""
        
        if components.count >= 2 {
            let firstLetter = String(components[0].prefix(1))
            let secondLetter = String(components[1].prefix(1))
            letters = firstLetter + secondLetter
        }
        roundLabel.text = letters.uppercased()
    }
    
    private func addGetStartedButtonAction() {
        getStartedButton.addAction(UIAction(handler: { [weak self] _ in
            self?.getStartedButtonDidTapCallback()
        }), for: .touchUpInside)
    }
    
    private func addLogInButtonAction() {
        logInButton.addAction(UIAction(handler: { [weak self] _ in
            self?.logInButtonDidTapCallback()
        }), for: .touchUpInside)
    }
    
    private func applyConstraints() {
        roundLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundLabel.widthAnchor.constraint(equalToConstant: roundWidthAndHeight),
            roundLabel.heightAnchor.constraint(equalToConstant: roundWidthAndHeight)
        ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.widthAnchor.constraint(equalTo: widthAnchor, constant: -stackHorzPadding)
        ])
        
        translatesAutoresizingMaskIntoConstraints = false
        // Avoid constraint's conflict when header is added to table view
        for constraint in constraints {
            constraint.priority = UILayoutPriority(750)
        }
    }
}
