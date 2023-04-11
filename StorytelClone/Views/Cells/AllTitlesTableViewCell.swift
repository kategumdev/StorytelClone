//
//  AllTitlesTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 7/4/23.
//

import UIKit

class AllTitlesTableViewCell: UITableViewCell {
    // MARK: - Static properties and methods
    static let identifier = "AllTitlesTableViewCell"
    static let imageWidthAndHeight: CGFloat = Utils.calculatedSmallSquareImageCoverSize.width
    static let minTopAndBottomPadding: CGFloat = Constants.cvPadding
    static let minCellHeight: CGFloat = imageWidthAndHeight + (minTopAndBottomPadding * 2)
    static let maxSubtitleLabelCount: Int = 4
    static let imageWidthPlusAllHorzPaddings: CGFloat = ( AllTitlesTableViewCell.imageWidthAndHeight + (Constants.cvPadding * 3))
    
    static func calculateLabelsHeight(forBook book: Book, andCellWidth cellWidth: CGFloat) -> CGFloat {
        // Height of titleLabel
        let titleLabel = createTitleLabel()
        titleLabel.text = book.title
        let titleLabelWidth = cellWidth - imageWidthPlusAllHorzPaddings
        let titleLabelHeight = titleLabel.sizeThatFits(CGSize(width: titleLabelWidth, height: CGFloat.greatestFiniteMagnitude)).height
        
        // Height of subtitleLabels
        let subtitleLabel = createSubtitleLabel()
        subtitleLabel.text = "This is subtitle"
        subtitleLabel.sizeToFit()

        var subtitleLabelCount = maxSubtitleLabelCount
        if book.narrators == nil { subtitleLabelCount -= 1 }
        if book.series == nil { subtitleLabelCount -= 1 }
        
        let heightOfSubtitleLabels = subtitleLabel.bounds.height * CGFloat(subtitleLabelCount)
        
        // Total labelsHeight
        let labelsHeight = titleLabelHeight + heightOfSubtitleLabels
        return labelsHeight
    }
    
    static func getEstimatedHeightForRowWith(width: CGFloat, andBook book: Book) -> CGFloat {
        let labelsHeight = calculateLabelsHeight(forBook: book, andCellWidth: width)
        
        let ratingHorzStackViewHeight = RatingHorzStackView.createCategoryLabel().bounds.height
        
        // Get total height
        var rowHeight: CGFloat = Constants.cvPadding * 3 + ratingHorzStackViewHeight
        if labelsHeight < imageWidthAndHeight {
            rowHeight += imageWidthAndHeight
        } else {
            rowHeight += labelsHeight
        }
        return rowHeight
    }

    static func createTitleLabel(withScaledFont: Bool = true) -> UILabel {
        let label = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, numberOfLines: 2, withScaledFont: withScaledFont)
        return label
    }
    
    static func createSubtitleLabel(withScaledFont: Bool = true) -> UILabel {
        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, withScaledFont: withScaledFont)
        return label
    }

    // MARK: - Instance properties
    private let bookTitleLabel = AllTitlesTableViewCell.createTitleLabel()
    private let bookKindLabel = AllTitlesTableViewCell.createSubtitleLabel()
    private let authorsLabel = AllTitlesTableViewCell.createSubtitleLabel()
    private let narratorsLabel = AllTitlesTableViewCell.createSubtitleLabel()
    private let seriesLabel = AllTitlesTableViewCell.createSubtitleLabel()

    lazy var vertStackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        [bookTitleLabel, bookKindLabel, authorsLabel, narratorsLabel, seriesLabel].forEach { stack.addArrangedSubview($0)}
        return stack
    }()
    
    private lazy var squareViewWithImageView: UIView = {
        let view = UIView()
        view.addSubview(customImageView)
        return view
    }()
    
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.bookCoverCornerRadius
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        imageView.layer.borderWidth = 0.26
        return imageView
    }()
    
    private lazy var customImageViewWidthAnchor = customImageView.widthAnchor.constraint(equalToConstant: AllTitlesTableViewCell.imageWidthAndHeight)
    
    private lazy var imageLabelsHorzStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Constants.cvPadding
        [squareViewWithImageView, vertStackWithLabels].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    lazy var ratingHorzStackView = RatingHorzStackView()
    
    private lazy var mainVertStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.cvPadding
        [imageLabelsHorzStack, ratingHorzStackView].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    // MARK: - View life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Utils.customBackgroundColor
        contentView.addSubview(mainVertStack)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            customImageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        }
    }
    
    // MARK: - Helper methods
    func configureFor(book: Book, popupButtonCallback: @escaping PopupButtonCallback) {
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
        }
        
        if let seriesTitle = book.series {
            seriesLabel.text = "Series: \(seriesTitle)"
        }

        if let image = book.coverImage {
            let resizedImage = image.resizeFor(targetHeight: AllTitlesTableViewCell.imageWidthAndHeight)
            
            if customImageView.bounds.width != image.size.width {
                customImageViewWidthAnchor.constant = resizedImage.size.width
            }
            customImageView.image = resizedImage
        }

        ratingHorzStackView.configureForAllTitleCellWith(book: book, popupButtonCallback: popupButtonCallback)
    }

    private func applyConstraints() {
        mainVertStack.translatesAutoresizingMaskIntoConstraints = false
        mainVertStack.fillSuperview(withConstant: Constants.cvPadding)

        customImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customImageView.topAnchor.constraint(equalTo: squareViewWithImageView.topAnchor),
            customImageView.heightAnchor.constraint(equalTo: squareViewWithImageView.heightAnchor),
            customImageView.centerXAnchor.constraint(equalTo: squareViewWithImageView.centerXAnchor),
        ])
        customImageViewWidthAnchor.isActive = true
        
        vertStackWithLabels.translatesAutoresizingMaskIntoConstraints = false
        let widthConstant = AllTitlesTableViewCell.imageWidthPlusAllHorzPaddings
        vertStackWithLabels.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -widthConstant).isActive = true
    }
    
}
