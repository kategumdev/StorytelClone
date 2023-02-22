//
//  BadgeView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/2/23.
//

import UIKit

class BadgeView: UIView {
    
    static let topAnchorPoints: CGFloat = 12

    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "badgeBorder")
        return view
    }()
    
    private let badgeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "badgeBackground")
        return view
    }()
    
    
    private let badgeImageView: UIImageView = {
        let imageView = UIImageView()
        var image = UIImage(systemName: "headphones")
//        image = image?.withRenderingMode(.alwaysOriginal)
        imageView.image = image
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = UIColor.label
        addSubview(borderView)
        addSubview(badgeBackgroundView)
        addSubview(badgeImageView)
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
        badgeBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        badgeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let badgeBackgroundViewConstraints = [
            badgeBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            badgeBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            badgeBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            badgeBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ]
        
        let badgeImageViewConstraints = [
            badgeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            badgeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            badgeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            badgeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(badgeBackgroundViewConstraints)
        NSLayoutConstraint.activate(badgeImageViewConstraints)
    }
}
