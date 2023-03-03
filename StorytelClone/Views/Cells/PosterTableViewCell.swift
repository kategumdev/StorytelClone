//
//  PosterTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

class PosterTableViewCell: UITableViewCell {
    static let identifier = "PosterTableViewCell"
    
    static let topPadding: CGFloat = 10
    
    static let calculatedWidth: CGFloat = UIScreen.main.bounds.size.width - (Constants.cvPadding * 2)
    
    static let calculatedHeightForRow: CGFloat = calculatedHeight + topPadding
    
    static let calculatedHeight: CGFloat = {
        let height = round(calculatedWidth + (calculatedWidth / 6))
        return height
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.bookCoverCornerRadius
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image1")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func applyConstraints() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
//        let width = contentView.bounds.width - (Constants.cvPadding * 2)
//        let height = round(width + (width / 6))
        
        NSLayoutConstraint.activate([
            posterImageView.widthAnchor.constraint(equalToConstant: PosterTableViewCell.calculatedWidth),
            posterImageView.heightAnchor.constraint(equalToConstant: PosterTableViewCell.calculatedHeight),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: PosterTableViewCell.topPadding),
            posterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding)
        ])
    }
}
