//
//  BookCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/2/23.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BookCollectionViewCell"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let badge: BadgeView = {
        let view = BadgeView(frame: .zero)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(coverImageView)
        contentView.addSubview(badge)
        applyBadgeConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coverImageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("BookCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    // HARDCODED IMAGES
    func configure(withImageNumber imageNumber: Int) {
        let imageName = "image\(imageNumber)"
        let image = UIImage(named: imageName)
        coverImageView.image = image
    }
    
    func applyBadgeConstraints() {
        badge.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            badge.trailingAnchor.constraint(equalTo: trailingAnchor),
            badge.topAnchor.constraint(equalTo: topAnchor, constant: -12),
            badge.widthAnchor.constraint(equalToConstant: 30),
            badge.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
