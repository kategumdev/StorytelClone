//
//  FollowSeriesView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 1/4/23.
//

import UIKit

class FollowSeriesView: UIView {
        
    private let imageHeightAndWidth: CGFloat = 50
    
    private lazy var calculatedTopAndBottomPadding: CGFloat = {
        // Not scaled font to calculate padding for default content size category
        let followLabel = createFollowLabel(withScaledFont: false)
        let numberOfFollowersLabel = createNumberOfFollowersLabel(withScaledFont: false)
//        titleLabel.text = "This is title"
//        subtitleLabel.text = "This is subtitle"
        followLabel.sizeToFit()
        numberOfFollowersLabel.sizeToFit()
        
        let labelsHeight = followLabel.bounds.height + numberOfFollowersLabel.bounds.height
        let padding = abs((imageHeightAndWidth - labelsHeight) / 2)
        return padding
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
//        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        button.tintColor = Utils.tintColor
        var config = UIButton.Configuration.filled()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let image = UIImage(systemName: "plus", withConfiguration: symbolConfig)?.withTintColor(Utils.customBackgroundLight)
        config.image = image
        config.cornerStyle = .capsule
//        config.contentInsets = NSDirectionalEdgeInsets(top: 9.5, leading: 9.5, bottom: 8.5, trailing: 8.5)
        button.configuration = config
        return button
    }()

    private lazy var followLabel = createFollowLabel(withScaledFont: true)
    private lazy var numberOfFollowersLabel = createNumberOfFollowersLabel(withScaledFont: true)
    
    private lazy var vertStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
//        stack.distribution = .fillProportionally
        
//        followLabel.sizeToFit()
//        numberOfFollowersLabel.sizeToFit()
        [followLabel, numberOfFollowersLabel].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(followButton)
        addSubview(vertStack)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(numberOfFollowers: Int) {
        numberOfFollowersLabel.text = "\(numberOfFollowers) Followers"
    }
    
    private func createFollowLabel(withScaledFont: Bool) -> UILabel {
        let label = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, withScaledFont: withScaledFont, text: "Follow")
        return label
    }
    
    private func createNumberOfFollowersLabel(withScaledFont: Bool) -> UILabel {
        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 45, withScaledFont: withScaledFont, textColor: Utils.seeAllButtonColor, text: "100 Followers")
        return label
    }
    
    private func applyConstraints() {
        followButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            followButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            followButton.widthAnchor.constraint(equalToConstant: imageHeightAndWidth),
            followButton.heightAnchor.constraint(equalToConstant: imageHeightAndWidth),
            followButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        vertStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vertStack.topAnchor.constraint(equalTo: topAnchor, constant: calculatedTopAndBottomPadding),
            vertStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -calculatedTopAndBottomPadding),
            vertStack.leadingAnchor.constraint(equalTo: followButton.trailingAnchor, constant: 14),
            vertStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
