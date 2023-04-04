//
//  StorytellerTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 4/4/23.
//

import UIKit

class StorytellerTableHeaderView: UIView {
    // MARK: - Instance properties
    private var storyteller: Title?
    private let roundWidthAndHeight: CGFloat = floor(UIScreen.main.bounds.width / 3)
        
    private lazy var roundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = roundWidthAndHeight / 2
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel.createLabel(withFont: UIFont.preferredCustomFontWith(weight: .semibold, size: 17), maximumPointSize: nil, withScaledFont: false, textColor: .label, text: "Name Surname")
        label.sizeToFit()
        return label
    }()
    
    private let titleKindLabel: UILabel = {
        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: nil, withScaledFont: false, textColor: .label, text: "titleKind")
        label.sizeToFit()
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
        button.tintColor = UIColor.label.withAlphaComponent(0.75)
        var config = UIButton.Configuration.plain()
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let image = UIImage(systemName: "person.2.fill", withConfiguration: symbolConfig)
        config.image = image
        config.imagePadding = 8
        
        config.attributedTitle = "100 Followers"
        config.attributedTitle?.font = Utils.sectionSubtitleFont
        config.attributedTitle?.foregroundColor = UIColor.label.withAlphaComponent(0.75)

        button.configuration = config
        return button
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        [roundView, nameLabel, titleKindLabel, followButton, numberOfFollowersButton].forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(7, after: nameLabel)
        return stack
    }()
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stack)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    func configureFor(storyteller: Title) {
        self.storyteller = storyteller
        titleKindLabel.text = storyteller.titleKind.rawValue

        if let author = storyteller as? Author {
            nameLabel.text = author.name
            
            numberOfFollowersButton.configuration?.attributedTitle = AttributedString("\(author.numberOfFollowers) Followers")
//            numberOfFollowersButton.configuration?.attributedTitle?.font = Utils.sectionSubtitleFont
        } else if let narrator = storyteller as? Narrator {
            nameLabel.text = narrator.name
            
            numberOfFollowersButton.configuration?.attributedTitle = AttributedString("\(narrator.numberOfFollowers) Followers")
//            numberOfFollowersButton.configuration?.attributedTitle?.font = Utils.sectionSubtitleFont
        }
        
        numberOfFollowersButton.configuration?.attributedTitle?.font = Utils.sectionSubtitleFont
    }
    
    private func applyConstraints() {
        roundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundView.widthAnchor.constraint(equalToConstant: roundWidthAndHeight),
            roundView.heightAnchor.constraint(equalToConstant: roundWidthAndHeight)
        ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
