//
//  BookCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/2/23.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BookCollectionViewCell"
    private let calculatedSquareCoverSize = Constants.calculatedSquareCoverSize
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.bookCoverCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let badge: BadgeView = {
        let view = BadgeView(frame: .zero)
        return view
    }()
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(coverImageView)
        contentView.addSubview(badge)
        applyConstraints()
//        contentView.backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("BookCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    // MARK: - Helper methods

    // HARDCODED IMAGES
    func configure(withImageNumber imageNumber: Int) {
        let imageName = "image\(imageNumber)"
        let image = UIImage(named: imageName)
        coverImageView.image = image
    }
    
    func applyConstraints() {
        
        badge.translatesAutoresizingMaskIntoConstraints = false
        let badgeConstraints = [
            badge.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            badge.topAnchor.constraint(equalTo: coverImageView.topAnchor, constant: -BadgeView.topAnchorPoints),
            badge.widthAnchor.constraint(equalToConstant: 30),
            badge.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(badgeConstraints)
        
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        let coverImageConstraints = [
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.widthAnchor.constraint(equalToConstant: calculatedSquareCoverSize.width),
            coverImageView.heightAnchor.constraint(equalToConstant: calculatedSquareCoverSize.height)
        ]
        
        NSLayoutConstraint.activate(coverImageConstraints)
    }
    
}
