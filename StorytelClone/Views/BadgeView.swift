//
//  BadgeView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/2/23.
//

import UIKit

class BadgeView: UIView {

    static let badgeWidthAndHeight: CGFloat = 28
    static let paddingBetweenBadges: CGFloat = 4
    static let badgeTopAnchorPoints: CGFloat = 12
    static let badgeBorderColor = UIColor(named: "badgeBorder")
    static let badgeBackgroundColor = UIColor(named: "badgeBackground")
    
    let badgeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
        
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

//
//class BadgeView: UIView {
//
//    static let badgeWidthAndHeight: CGFloat = 30
//    static let paddingBetweenBadges: CGFloat = 4
//    static let badgeTopAnchorPoints: CGFloat = 12
//
//    private let borderView = UIView()
//    private let badgeBackgroundView = UIView()
//
//    let badgeImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        tintColor = UIColor.label
//        addSubview(borderView)
//        addSubview(badgeBackgroundView)
//        addSubview(badgeImageView)
//        borderView.backgroundColor = Utils.badgeBorderColor
//        badgeBackgroundView.backgroundColor = Utils.badgeBackgroundColor
//        applyConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        borderView.frame = bounds
//        configure()
//    }
//
//    // MARK: - Helper methods
//    private func configure() {
//        borderView.layer.cornerRadius = borderView.bounds.width / 2
//        borderView.clipsToBounds = true
//
//        badgeBackgroundView.layer.cornerRadius = badgeBackgroundView.bounds.width / 2
//        badgeBackgroundView.clipsToBounds = true
//    }
//
//    private func applyConstraints() {
//        badgeBackgroundView.fillSuperview(withConstant: 2)
//        badgeImageView.fillSuperview(withConstant: 5)
//    }
//
//}

