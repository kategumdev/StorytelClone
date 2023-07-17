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
    static let badgeBackgroundColor = UIColor(named: "badgeBackground")
    
    // MARK: - Instance properties
    private var borderColor: CGColor? {
        return UIColor(named: "badgeBorder")?.cgColor
    }
    
    let badgeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
        
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = borderColor
        }
    }
    
    // MARK: - Helper method
    private func setupUI() {
        tintColor = UIColor.label
        layer.borderColor = borderColor
        layer.borderWidth = 1
        clipsToBounds = true
        backgroundColor = BadgeView.badgeBackgroundColor
        addSubview(badgeImageView)
        badgeImageView.fillSuperview(withConstant: 5)
    }
}
