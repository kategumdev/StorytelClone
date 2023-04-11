//
//  BadgeView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/2/23.
//

import UIKit

class BadgeView: UIView {
    // MARK: - Static properties
    static let badgeWidthAndHeight: CGFloat = 28
    static let paddingBetweenBadges: CGFloat = 4
    static let badgeTopAnchorPoints: CGFloat = 12
    static let badgeBorderColor = UIColor(named: "badgeBorder")
    static let badgeBackgroundColor = UIColor(named: "badgeBackground")
    
    // MARK: - Instance properties
    let badgeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
        
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = UIColor.label
        layer.borderColor = BadgeView.badgeBorderColor?.cgColor
        layer.borderWidth = 1
        clipsToBounds = true
        backgroundColor = BadgeView.badgeBackgroundColor
        addSubview(badgeImageView)
        badgeImageView.fillSuperview(withConstant: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = BadgeView.badgeBorderColor?.cgColor
        }
    }

}
