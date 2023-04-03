//
//  FollowSeriesView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 1/4/23.
//

import UIKit

class FollowSeriesView: UIView {
        
    // MARK: - Instance properties
    private let imageHeightAndWidth: CGFloat = 50
    private var seriesIsFollowed = false
    private var numberOfFollowers = 0
    
    private lazy var calculatedTopAndBottomPadding: CGFloat = {
        // Not scaled font to calculate padding for default content size category
        let followLabel = createFollowLabel(withScaledFont: false)
        let numberOfFollowersLabel = createNumberOfFollowersLabel(withScaledFont: false)
        followLabel.sizeToFit()
        numberOfFollowersLabel.sizeToFit()
        
        let labelsHeight = followLabel.bounds.height + numberOfFollowersLabel.bounds.height
        let padding = abs((imageHeightAndWidth - labelsHeight) / 2)
        return padding
    }()
        
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = imageHeightAndWidth / 2
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
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(followButton)
        addSubview(vertStack)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) && seriesIsFollowed {
            followButton.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    // MARK: - Helper methods
    func configureWith(series: Series) {
        seriesIsFollowed = series.isFollowed
        
        toggleFollowLabelText()
        toggleButtonAppearance()
        
        addButtonAction()
//        let numberOfFollowers = series.numberOfFollowers
        numberOfFollowers = series.numberOfFollowers
        numberOfFollowersLabel.text = "\(numberOfFollowers) Followers"
    }
    
    private func addButtonAction() {
        followButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            
            self.seriesIsFollowed = !self.seriesIsFollowed
            self.toggleButton()
            // Also new isFollowed value of series model object must be saved here
        }), for: .touchUpInside)
    }
    
    
    private func toggleButton() {
        toggleFollowLabelText()
        
        configureActivityIndicator(show: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self = self else { return }
            self.configureActivityIndicator(show: false)
            self.toggleButtonAppearance()
            self.updateNumberOfFollowers()
        }
    }
    
    private func toggleFollowLabelText() {
        followLabel.text = seriesIsFollowed ? "Following" : "Follow"
    }
    
    private func updateNumberOfFollowers() {
        numberOfFollowers = seriesIsFollowed ? numberOfFollowers + 1 : numberOfFollowers - 1
        numberOfFollowersLabel.text = "\(numberOfFollowers) Followers"
    }
    
    private func toggleButtonAppearance() {
        var config = UIButton.Configuration.plain()
        
        if !seriesIsFollowed {
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
            let image = UIImage(systemName: "plus", withConfiguration: symbolConfig)
            config.image = image
            followButton.tintColor = Utils.customBackgroundLight
            followButton.backgroundColor = Utils.tintColor
            followButton.layer.borderColor = UIColor.clear.cgColor
        } else {
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
            let image = UIImage(systemName: "checkmark", withConfiguration: symbolConfig)
            config.image = image
            followButton.tintColor = UIColor.label
            followButton.backgroundColor = .clear
            followButton.layer.borderWidth = 1.8
            followButton.layer.borderColor = UIColor.label.cgColor
        }
        
        followButton.configuration = config
    }
    
    #warning("Activity indicator must show while context is saving new isFollowed value of the series model object")
    // Activity indicator must show while context is saving new isFollowed value of the series model object
    private func configureActivityIndicator(show: Bool) {
        var config = followButton.configuration
        config?.showsActivityIndicator = show
        followButton.configuration = config
        followButton.isUserInteractionEnabled = !show
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
