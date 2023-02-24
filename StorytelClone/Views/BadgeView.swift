//
//  BadgeView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/2/23.
//

import UIKit

class BadgeView: UIView {

    static let badgeWidthAndHeight: CGFloat = 30
    static let paddingBetweenBadges: CGFloat = 5
    static let badgeTopAnchorPoints: CGFloat = 12

    private let borderView = UIView()
    private let badgeBackgroundView = UIView()
    
    let badgeImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = UIColor.label
        addSubview(borderView)
        addSubview(badgeBackgroundView)
        addSubview(badgeImageView)
        borderView.backgroundColor = UIColor(named: "badgeBorder")
        badgeBackgroundView.backgroundColor = UIColor(named: "badgeBackground")
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderView.frame = bounds
        configure()
    }
    
    // MARK: - Helper methods
    private func configure() {
        borderView.layer.cornerRadius = borderView.bounds.width / 2
        borderView.clipsToBounds = true
        
        badgeBackgroundView.layer.cornerRadius = badgeBackgroundView.bounds.width / 2
        badgeBackgroundView.clipsToBounds = true
    }

    private func applyConstraints() {
        badgeBackgroundView.fillSuperview(withConstant: 2)
        badgeImageView.fillSuperview(withConstant: 5)
    }
    
}
