//
//  ResultsTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/3/23.
//

import UIKit

class SearchResultsBookTableViewCell: SearchResultsTableViewCell {

    static let identifier = "ResultsTableViewCell"
    
//    static let minTopAndBottomPadding: CGFloat = 13
//    static let imageHeight: CGFloat = ceil(UIScreen.main.bounds.width * 0.19)
    static let minCellHeight: CGFloat = imageHeight + (minTopAndBottomPadding * 2)
    
    static let calculatedTopAndBottomPadding: CGFloat = {
        // Not scaled font to calculate padding for default content size category
        let titleLabel = createTitleLabel(withScaledFont: false)
        let subtitleLabel = createSubtitleLabel(withScaledFont: false)
        titleLabel.text = "This is title"
        subtitleLabel.text = "This is subtitle"
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        
        let labelsHeight = titleLabel.bounds.height + (subtitleLabel.bounds.height * 3)
        let padding = abs((minCellHeight - labelsHeight) / 2)
        return padding
    }()
    
    static func getEstimatedHeightForRow() -> CGFloat {
        let labelsHeight = calculateLabelsHeightWith(subtitleLabelNumber: 3)
        let rowHeight = labelsHeight + calculatedTopAndBottomPadding * 2
        return rowHeight
    }
    
    private let bookTitleLabel = SearchResultsTableViewCell.createTitleLabel()
    private let bookKindLabel = SearchResultsTableViewCell.createSubtitleLabel()
    private let authorsLabel = SearchResultsTableViewCell.createSubtitleLabel()
    private let narratorsLabel = SearchResultsTableViewCell.createSubtitleLabel()

    lazy var vertStackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        [bookTitleLabel, bookKindLabel, authorsLabel, narratorsLabel].forEach { stack.addArrangedSubview($0)}
        return stack
    }()
    
    private lazy var squareViewWithImageView: UIView = {
        let view = UIView()
        view.addSubview(customImageView)
        return view
    }()
    
    private let customImageView: UIImageView = {
        let imageView = SearchResultsTableViewCell.createImageView()
        imageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        imageView.layer.borderWidth = 0.26
        return imageView
    }()
    
//    private let customImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.layer.cornerRadius = 2
//        imageView.clipsToBounds = true
//        imageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
//        imageView.layer.borderWidth = 0.26
//        return imageView
//    }()
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(squareViewWithImageView)
        contentView.addSubview(vertStackWithLabels)
        contentView.addSubview(detailButton)
        applyConstraints()
    }
    
    private lazy var customImageViewWidthAnchor = customImageView.widthAnchor.constraint(equalToConstant: SearchResultsTableViewCell.imageHeight)

    
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

        let authorNames = book.authors.map { $0.name }
        let authorNamesString = authorNames.joined(separator: ", ")
        authorsLabel.text = "By: \(authorNamesString)"
        
        if let narrators = book.narrators {
            let narratorNames = narrators.map { $0.name }
            let narratorNamesString = narratorNames.joined(separator: ", ")
            narratorsLabel.text = "With: \(narratorNamesString)"
            narratorsLabel.textColor = UIColor.label
        } else {
            // This is needed to take height of this label into account when system calculates automaticDimension for this cell
            narratorsLabel.text = "Placeholder"
            narratorsLabel.textColor = UIColor.clear
        }
        
        if let image = book.coverImage {
//            print("image size before: \(image.size)")
//            let imageRatio = image.size.width / image.size.height
//            let targetHeight = SearchResultsTableViewCell.imageHeight
//            let targetWidth = targetHeight * imageRatio
//            let targetSize = CGSize(width: targetWidth, height: targetHeight)
//
//            let renderer = UIGraphicsImageRenderer(size: targetSize)
//            let resizedImage = renderer.image { _ in
//                image.draw(in: CGRect(origin: .zero, size: targetSize))
//            }
            let resizedImage = image.resizeFor(targetHeight: SearchResultsTableViewCell.imageHeight)
            
            if customImageView.bounds.width != image.size.width {
                customImageViewWidthAnchor.constant = resizedImage.size.width
            }

            customImageView.image = resizedImage
        }

    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        squareViewWithImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            squareViewWithImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
            squareViewWithImageView.widthAnchor.constraint(equalToConstant: SearchResultsTableViewCell.squareImageWidth),
            squareViewWithImageView.heightAnchor.constraint(equalToConstant: SearchResultsTableViewCell.imageHeight),
            squareViewWithImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customImageView.topAnchor.constraint(equalTo: squareViewWithImageView.topAnchor),
            customImageView.heightAnchor.constraint(equalTo: squareViewWithImageView.heightAnchor),
            customImageView.centerXAnchor.constraint(equalTo: squareViewWithImageView.centerXAnchor),
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
            vertStackWithLabels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultsBookTableViewCell.calculatedTopAndBottomPadding),
            vertStackWithLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SearchResultsBookTableViewCell.calculatedTopAndBottomPadding),
            vertStackWithLabels.leadingAnchor.constraint(equalTo: squareViewWithImageView.trailingAnchor, constant: Constants.cvPadding),
            vertStackWithLabels.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor, constant: -Constants.cvPadding)
        ])
    }

}
