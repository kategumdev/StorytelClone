//
//  ResultsTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/3/23.
//

import UIKit

class SearchResultsBookTableViewCell: UITableViewCell {

    static let identifier = "ResultsTableViewCell"
    
    static let topAndBottomPadding: CGFloat = 15
//    static let contentViewWidthFraction: CGFloat = 4
    static let imageHeight: CGFloat = ceil(UIScreen.main.bounds.width * 0.19)
//    static let imageHeight: CGFloat = ceil(UIScreen.main.bounds.width / 5)

    static func getEstimatedHeightForRow() -> CGFloat {
        let titleLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45)
        let subtitleLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38)
    
        titleLabel.text = "This is title"
        subtitleLabel.text = "This is subtitle"
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        
        let rowHeight = titleLabel.bounds.height + (subtitleLabel.bounds.height * 3) + (topAndBottomPadding * 2)
        
        return rowHeight
    }

//    private lazy var imageHeight: CGFloat = ceil(contentView.bounds.width / SearchResultsBookTableViewCell.contentViewWidthFraction)
    
    lazy var vertStackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        [bookTitleLabel, bookKindLabel, authorLabel, narratorLabel].forEach { stack.addArrangedSubview($0)}
        return stack
    }()
    
    private lazy var viewWithImageView: UIView = {
        let view = UIView()
        view.addSubview(customImageView)
        return view
    }()
    
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        imageView.layer.borderWidth = 0.26
        return imageView
    }()
    
    private let detailButton: UIButton = {
        let button = UIButton()
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold)
        let fixedSizeImage = UIImage(systemName: "ellipsis", withConfiguration: symbolConfig)
        
        var config = UIButton.Configuration.plain()
        config.image = fixedSizeImage
        config.baseForegroundColor = UIColor.label
        button.configuration = config
        return button
    }()
    
    private let bookTitleLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45)
    private let bookKindLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38)
    private let authorLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38)
    private let narratorLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38)
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Utils.customBackgroundColor
        
        contentView.addSubview(viewWithImageView)
        contentView.addSubview(vertStackWithLabels)
        contentView.addSubview(detailButton)
        applyConstraints()
    }
    
    private lazy var customImageViewWidthAnchor =             customImageView.widthAnchor.constraint(equalToConstant: SearchResultsBookTableViewCell.imageHeight)

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            customImageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        }
    }
    
    func configureFor(book: Book) {
        bookTitleLabel.text = book.title
        bookKindLabel.text = book.titleKind.rawValue
        authorLabel.text = "By: \(book.author)"
        
        if let narrators = book.narrators {
            narratorLabel.text = "With: \(narrators)"
            narratorLabel.textColor = UIColor.label
        } else {
            // This is needed to take height of this label into account when system calculates automaticDimension for this cell
            narratorLabel.text = "Placeholder"
            narratorLabel.textColor = UIColor.clear
        }
        
        if let image = book.coverImage {
//            print("image size before: \(image.size)")
            let imageRatio = image.size.width / image.size.height
            let targetHeight = SearchResultsBookTableViewCell.imageHeight
            let targetWidth = targetHeight * imageRatio
            let targetSize = CGSize(width: targetWidth, height: targetHeight)
            
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            let resizedImage = renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: targetSize))
            }
            
            if customImageView.bounds.width != image.size.width {
                customImageViewWidthAnchor.constant = resizedImage.size.width
            }

            customImageView.image = resizedImage
        }

    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        
        viewWithImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewWithImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
            viewWithImageView.widthAnchor.constraint(equalToConstant: SearchResultsBookTableViewCell.imageHeight),
            viewWithImageView.heightAnchor.constraint(equalToConstant: SearchResultsBookTableViewCell.imageHeight),
            viewWithImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customImageView.topAnchor.constraint(equalTo: viewWithImageView.topAnchor),
            customImageView.heightAnchor.constraint(equalTo: viewWithImageView.heightAnchor),
            customImageView.centerXAnchor.constraint(equalTo: viewWithImageView.centerXAnchor),
        ])
        customImageViewWidthAnchor.isActive = true
        
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cvPadding),
            detailButton.widthAnchor.constraint(equalToConstant: 30),
            detailButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        vertStackWithLabels.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vertStackWithLabels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultsBookTableViewCell.topAndBottomPadding),
            vertStackWithLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SearchResultsBookTableViewCell.topAndBottomPadding),
            vertStackWithLabels.leadingAnchor.constraint(equalTo: viewWithImageView.trailingAnchor, constant: Constants.cvPadding),
            vertStackWithLabels.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor, constant: -Constants.cvPadding)
        ])
    }

}
