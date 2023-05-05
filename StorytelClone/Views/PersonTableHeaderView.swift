//
//  PersonTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 4/4/23.
//

import UIKit

class PersonTableHeaderView: UIView {
    
//    enum HeaderKind: Equatable {
//        case forStoryteller(storyteller: Storyteller)
//        case forProfile
//    }
    
    enum HeaderKind: Equatable {
        case forStoryteller(storyteller: Storyteller, superviewWidth: CGFloat)
        case forProfile
    }

    // MARK: - Instance properties
    private let lighterLabelColor = UIColor.label.withAlphaComponent(0.75)
    private let roundWidthAndHeight: CGFloat = floor(UIScreen.main.bounds.width / 3)
    private let stackHorzPadding: CGFloat = 20
    private let kind: HeaderKind
    
    private lazy var roundLabel: UILabel = {
        let label = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .semibold, size: 35), maximumPointSize: 58, textColor: lighterLabelColor)
        label.textAlignment = .center
        label.backgroundColor = UIColor.systemGray5
        label.layer.cornerRadius = roundWidthAndHeight / 2
        label.clipsToBounds = true
        return label
    }()

//    private lazy var storytellerNameLabel = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .semibold, size: 17), maximumPointSize: 48, numberOfLines: 2)
    
    private lazy var storytellerNameLabel: UILabel = {
       let label = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .semibold, size: 17), maximumPointSize: 48, numberOfLines: 2)
        label.textAlignment = .center
        return label
    }()
    
//    private lazy var storytellerNameLabel = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .semibold, size: 17), maximumPointSize: 48, numberOfLines: 0)

    
    private lazy var storytellerKindLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38)
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.systemGray4.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.background.backgroundColor = .systemGray2
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let image = UIImage(systemName: "plus", withConfiguration: symbolConfig)
        config.image = image
        config.imagePadding = 10
        
        config.attributedTitle = "Follow"
        let font = Utils.sectionTitleFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 45)
        config.attributedTitle?.font = scaledFont
        config.attributedTitle?.foregroundColor = Utils.customBackgroundLight
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 44, bottom: 13, trailing: 44)
        button.configuration = config
        return button
    }()
    
    private lazy var numberOfFollowersButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.tintColor = lighterLabelColor
        var config = UIButton.Configuration.plain()
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let image = UIImage(systemName: "person.2.fill", withConfiguration: symbolConfig)
        config.image = image
        config.imagePadding = 8
        
        config.attributedTitle = "100 Followers"
        let font = Utils.sectionSubtitleFont
        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 34)
        config.attributedTitle?.font = scaledFont
        config.attributedTitle?.foregroundColor = lighterLabelColor

        button.configuration = config
        return button
    }()
    
    private lazy var greetingsLabel = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .semibold, size: 19), maximumPointSize: 48, withScaledFont: true, textColor: .label, text: "Hi!")
    
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
    
    private lazy var questionLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 34, withScaledFont: true, textColor: .label, text: "Already have an account?")
    
    private lazy var logInButton: UIButton = {
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
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
//    private var stackViewWidth
    
//    private var previousStackHeight: CGFloat = 0
    
    private var isNotConfigured = true
    
    // MARK: - Initializers
    init(kind: HeaderKind) {
        self.kind = kind
        super.init(frame: .zero)
        configureSelf()
        addSubview(stack)
        applyConstraints()
//        configureSelf()
        
        storytellerNameLabel.backgroundColor = .systemPink
        stack.backgroundColor = .green
        backgroundColor = .blue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
//        print("stack width = \(stack.bounds.width)")
//        storytellerNameLabel.preferredMaxLayoutWidth = stack.bounds.width
//        layoutIfNeeded()

//        guard isNotConfigured else { return }
//        configureSelf()

//        if isNotConfigured {
//            print("isNotConfigured")
//            configureSelf()
////            setNeedsLayout()
////            layoutIfNeeded()
////            isNotConfigured = false
//        }
        
//        if storytellerNameLabel.preferredMaxLayoutWidth != stack.bounds.width {
//            let label = storytellerNameLabel
//            label.preferredMaxLayoutWidth = stack.bounds.width
//            storytellerNameLabel = label
////            storytellerNameLabel.preferredMaxLayoutWidth = stack.bounds.width
//            setNeedsLayout()
//            layoutIfNeeded()
//        }
//         print("storytellerNameLabel.bounds.height \(storytellerNameLabel.bounds.height)")
//        storytellerNameLabel.preferredMaxLayoutWidth = stack.frame.size.width
//        storytellerNameLabel.sizeToFit()
//        print("storytellerNameLabel.bounds.height \(storytellerNameLabel.bounds.height)")

//        if storytellerNameLabel.bounds.height == 0 {
//            setNeedsLayout()
//            layoutIfNeeded()
//        }
//        if previousStackHeight != stack.bounds.height {
//            setNeedsLayout()
//            layoutIfNeeded()
////            previousStackHeight = stack.bounds.height
//        }
//        previousStackHeight = stack.bounds.height
        
//        print("storytellerNameLabel height BEFORE: \(storytellerNameLabel.bounds.height)")
//        let height = storytellerNameLabel.sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
//        storytellerNameLabel.frame.size.height = height
//        print("storytellerNameLabel height AFTER: \(storytellerNameLabel.bounds.height)")
//
//        if storytellerNameLabel.frame.size.height != height {
//            storytellerNameLabel.frame.size.height = height
//            stack.setNeedsLayout()
//            stack.layoutIfNeeded()
//        }

//        if storytellerNameLabel.frame.size.height != size.height {
//            storytellerNameLabel.frame.size.height = size.height
//        }
//        storytellerNameLabel.sizeToFit()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if kind == .forProfile {
                logInButton.layer.borderColor = UIColor.label.cgColor
            }
        }
        
//        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
//            stack.setNeedsLayout()
//            stack.layoutIfNeeded()
//        }
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        switch kind {
        case .forStoryteller(let storyteller, let superviewWidth): configureFor(storyteller: storyteller, superviewWidth: superviewWidth)
//        case .forStoryteller(let storyteller): configureFor(storyteller: storyteller)
        case .forProfile: configureForProfile()
        }
    }
    
    private func configureFor(storyteller: Storyteller, superviewWidth: CGFloat) {
        // Configure stack itself
        stack.spacing = 20
        [roundLabel, storytellerNameLabel, storytellerKindLabel, followButton, numberOfFollowersButton].forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(7, after: storytellerNameLabel)

        // Configure stack subviews
        storytellerKindLabel.text = storyteller.titleKind.rawValue

        storytellerNameLabel.text = storyteller.name
        storytellerNameLabel.preferredMaxLayoutWidth = superviewWidth - stackHorzPadding

        configureRoundLabelWithLettersFrom(name: storyteller.name)

        let numberOfFollowers = storyteller.numberOfFollowers.shorted()
        numberOfFollowersButton.configuration?.attributedTitle = AttributedString("\(numberOfFollowers) Followers")

        numberOfFollowersButton.configuration?.attributedTitle?.font = Utils.sectionSubtitleFont
    }
    
//    private func configureFor(storyteller: Storyteller) {
//        // Configure stack itself
//        stack.spacing = 20
//        [roundLabel, storytellerNameLabel, storytellerKindLabel, followButton, numberOfFollowersButton].forEach { stack.addArrangedSubview($0) }
//        stack.setCustomSpacing(7, after: storytellerNameLabel)
//
//        // Configure stack subviews
//        storytellerKindLabel.text = storyteller.titleKind.rawValue
//
//        storytellerNameLabel.text = storyteller.name
////        let stackWidth = stack.bounds.width
////        storytellerNameLabel.preferredMaxLayoutWidth = stackWidth
//        storytellerNameLabel.preferredMaxLayoutWidth = stack.bounds.width
////        storytellerNameLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
//        storytellerNameLabel.textAlignment = .center
////        storytellerNameLabel.translatesAutoresizingMaskIntoConstraints = false
////        storytellerNameLabel.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
////        storytellerNameLabel.sizeToFit()
//        configureRoundLabelWithLettersFrom(name: storyteller.name)
//
//        let numberOfFollowers = storyteller.numberOfFollowers.shorted()
//        numberOfFollowersButton.configuration?.attributedTitle = AttributedString("\(numberOfFollowers) Followers")
//
//        numberOfFollowersButton.configuration?.attributedTitle?.font = Utils.sectionSubtitleFont
//    }
    
    private func configureForProfile() {
        // Configure stack itself
        stack.spacing = 16
        [roundLabel, greetingsLabel, getStartedButton, questionLabel, logInButton].forEach { stack.addArrangedSubview($0) }
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
    
    private func convertNumber(number: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        let scientificNumber = formatter.string(for: number)!
        print("\(number) spelled out is \(scientificNumber).")
    }
    
    private func applyConstraints() {
        roundLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundLabel.widthAnchor.constraint(equalToConstant: roundWidthAndHeight),
            roundLabel.heightAnchor.constraint(equalToConstant: roundWidthAndHeight)
        ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
//        let leadingTrailingConstant: CGFloat = 10
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: stackHorzPadding / 2),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -stackHorzPadding / 2),
            stack.widthAnchor.constraint(equalTo: widthAnchor, constant: -stackHorzPadding)
        ])
        
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        let leadingTrailingConstant: CGFloat = 10
//        NSLayoutConstraint.activate([
//            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),
//            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingTrailingConstant),
//            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingTrailingConstant),
//            stack.widthAnchor.constraint(equalTo: widthAnchor, constant: -leadingTrailingConstant * 2)
//        ])
        
        translatesAutoresizingMaskIntoConstraints = false
        // Avoid constraint's conflict when header is added to table view
        for constraint in constraints {
            constraint.priority = UILayoutPriority(750)
        }
    }

}
