//
//  StorytellerTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 4/4/23.
//

import UIKit

class StorytellerTableHeaderView: UIView {
    // MARK: - Static property
    static let lighterLabelColor = UIColor.label.withAlphaComponent(0.75)
    static let roundWidthAndHeight: CGFloat = floor(UIScreen.main.bounds.width / 3)
    static let roundBackgroundColor = UIColor.systemGray5

    // MARK: - Instance properties
//    private let roundWidthAndHeight: CGFloat = floor(UIScreen.main.bounds.width / 3)
        
    private lazy var roundLabelWithLetters: UILabel = {
//        let label = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .semibold, size: 35), maximumPointSize: nil, withScaledFont: false, textColor: StorytellerTableHeaderView.lighterLabelColor, text: "NS")
        let label = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .semibold, size: 35), maximumPointSize: 60, textColor: StorytellerTableHeaderView.lighterLabelColor)
        label.textAlignment = .center
        label.backgroundColor = StorytellerTableHeaderView.roundBackgroundColor
        label.layer.cornerRadius = StorytellerTableHeaderView.roundWidthAndHeight / 2
        label.clipsToBounds = true
        return label
    }()
    
    private let nameLabel: UILabel = {
//        let label = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .semibold, size: 17), maximumPointSize: nil, withScaledFont: false, textColor: .label, text: "Name Surname")
        let label = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .semibold, size: 17), maximumPointSize: 48)
//        label.sizeToFit()
        return label
    }()
    
    private let titleKindLabel: UILabel = {
//        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: nil, withScaledFont: false, textColor: .label)
        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38)
//        label.sizeToFit()
        return label
    }()
    
    private let followButton: UIButton = {
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
    
    private let numberOfFollowersButton: UIButton = {
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
//        config.attributedTitle?.font = Utils.sectionSubtitleFont
        
        config.attributedTitle?.foregroundColor = lighterLabelColor

        button.configuration = config
        return button
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        [roundLabelWithLetters, nameLabel, titleKindLabel, followButton, numberOfFollowersButton].forEach { stack.addArrangedSubview($0) }

        stack.setCustomSpacing(7, after: nameLabel)
        return stack
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stack)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureFor(storyteller: Storyteller) {
        titleKindLabel.text = storyteller.titleKind.rawValue
                
        nameLabel.text = storyteller.name
        configureRoundLabelWithLettersFrom(name: storyteller.name)
        
        let numberOfFollowers = storyteller.numberOfFollowers.shorted()
        numberOfFollowersButton.configuration?.attributedTitle = AttributedString("\(numberOfFollowers) Followers")
        
        numberOfFollowersButton.configuration?.attributedTitle?.font = Utils.sectionSubtitleFont
    }
    
    // MARK: - Helper methods
    private func configureRoundLabelWithLettersFrom(name: String) {
        let originalString = name
        let components = originalString.components(separatedBy: " ")
        var letters = ""

        if components.count >= 2 {
            let firstLetter = String(components[0].prefix(1))
            let secondLetter = String(components[1].prefix(1))
            letters = firstLetter + secondLetter
        }
        roundLabelWithLetters.text = letters.uppercased()
    }
    
    private func convertNumber(number: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        let scientificNumber = formatter.string(for: number)!
        print("\(number) spelled out is \(scientificNumber).")
    }
    
    private func applyConstraints() {
        roundLabelWithLetters.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundLabelWithLetters.widthAnchor.constraint(equalToConstant: StorytellerTableHeaderView.roundWidthAndHeight),
            roundLabelWithLetters.heightAnchor.constraint(equalToConstant: StorytellerTableHeaderView.roundWidthAndHeight)
        ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        translatesAutoresizingMaskIntoConstraints = false
        // Avoid constraint's conflict when header is added to table view
        for constraint in constraints {
            constraint.priority = UILayoutPriority(750)
        }
    }
}
