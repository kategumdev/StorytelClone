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
    
    static var calculatedTopAndBottomPadding: CGFloat = 0
    
//    static var calculatedTopAndBottomPadding: CGFloat = {
//        // Not scaled font to calculate padding for default content size category
//        let titleLabel = createTitleLabel(withScaledFont: false)
//        let subtitleLabel = createSubtitleLabel(withScaledFont: false)
//        titleLabel.text = "This is title"
//        subtitleLabel.text = "This is subtitle"
//        titleLabel.sizeToFit()
//        subtitleLabel.sizeToFit()
//
//        let labelsHeight = titleLabel.bounds.height + (subtitleLabel.bounds.height * 3)
//        let padding = abs((minCellHeight - labelsHeight) / 2)
//        return padding
//    }()
    
    
    static func calculateTopAndBottomPadding(forBook book: Book, subtitleLabelNumber: Int, labelWidth: CGFloat) -> CGFloat{
        // Not scaled font to calculate padding for default content size category
        let titleLabel = createTitleLabel(withScaledFont: false)
        let subtitleLabel = createSubtitleLabel(withScaledFont: false)
//        titleLabel.text = "This is title"
        titleLabel.text = book.title
        subtitleLabel.text = "This is subtitle"
//        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()

        let titleLabelHeight = titleLabel.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)).height

        let labelsHeight = titleLabelHeight + subtitleLabel.bounds.height * CGFloat(subtitleLabelNumber)

//        let labelsHeight = titleLabel.bounds.height + (subtitleLabel.bounds.height * 3)
        let padding = abs((minCellHeight - labelsHeight) / 2)
        return padding
    }
    
    static func calculateLabelsHeightWith(subtitleLabelNumber: Int, labelWidth: CGFloat, forBook book: Book) -> CGFloat {
        let titleLabel = createTitleLabel()
        let subtitleLabel = createSubtitleLabel()
        titleLabel.text = book.title
//        titleLabel.text = "This is title"
        subtitleLabel.text = "This is subtitle"
//        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        
        let titleLabelHeight = titleLabel.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)).height
        
        let labelsHeight = titleLabelHeight + subtitleLabel.bounds.height * CGFloat(subtitleLabelNumber)

        print("calculateLabelsHeightWith: \(labelsHeight)")
//        let labelsHeight = titleLabel.bounds.height + titleLabel.bounds.height * CGFloat(subtitleLabelNumber)
        return labelsHeight
    }
    
//    static func calculateLabelsHeightWith(subtitleLabelNumber: Int) -> CGFloat {
//        let titleLabel = createTitleLabel()
//        let subtitleLabel = createSubtitleLabel()
//        titleLabel.text = "This is title"
//        subtitleLabel.text = "This is subtitle"
//        titleLabel.sizeToFit()
//        subtitleLabel.sizeToFit()
//
//        let labelsHeight = titleLabel.bounds.height + titleLabel.bounds.height * CGFloat(subtitleLabelNumber)
//        return labelsHeight
//    }
    
    static func getEstimatedHeightForRow(subtitleLabelNumber: Int, labelWidth: CGFloat, forBook book: Book) -> CGFloat {
        let labelsHeight = calculateLabelsHeightWith(subtitleLabelNumber: 3, labelWidth: labelWidth, forBook: book)
        
//        var rowHeight: CGFloat
//        if labelsHeight > AllTitlesTableViewCell.imageWidthAndHeight {
//            rowHeight = labelsHeight + calculatedTopAndBottomPadding * 2 + Constants.cvPadding * 2
//        } else {
//            rowHeight = AllTitlesTableViewCell.imageWidthAndHeight
//        }
        
//        let rowHeight = labelsHeight + calculatedTopAndBottomPadding * 2
//        let calculatedTopAndBottomPadding = calculatedTopAndBottomPadding(subtitleLabelNumber: subtitleLabelNumber, labelWidth: labelWidth, forBook: book)
        let rowHeight = labelsHeight + calculatedTopAndBottomPadding * 2 + Constants.cvPadding * 2
        print("getEstimatedHeightForRow: \(rowHeight)")
        return rowHeight
    }
    //    static func getEstimatedHeightForRow() -> CGFloat {
    //        let labelsHeight = calculateLabelsHeightWith(subtitleLabelNumber: 3)
    //        let rowHeight = labelsHeight + calculatedTopAndBottomPadding * 2
    //        print("getEstimatedHeightForRow: \(rowHeight)")
    //        return rowHeight
    //    }
        
    static func createTitleLabel(withScaledFont: Bool = true) -> UILabel {
//        let label = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, withScaledFont: withScaledFont)
        let label = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, numberOfLines: 2, withScaledFont: withScaledFont)
        return label
    }
    
    static func createSubtitleLabel(withScaledFont: Bool = true) -> UILabel {
        let label = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, withScaledFont: withScaledFont)
        return label
    }
    

    
    // MARK: - Instance properties
//    private let imageWidthAndHeight: CGFloat = Utils.calculatedSmallSquareImageCoverSize.width
        
    private let bookTitleLabel = AllTitlesTableViewCell.createTitleLabel()
    private let bookKindLabel = AllTitlesTableViewCell.createSubtitleLabel()
    private let authorsLabel = AllTitlesTableViewCell.createSubtitleLabel()
    private let narratorsLabel = AllTitlesTableViewCell.createSubtitleLabel()

    lazy var vertStackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
//        stack.distribution = .fillProportionally
        [bookTitleLabel, bookKindLabel, authorsLabel, narratorsLabel].forEach { stack.addArrangedSubview($0)}
        stack.backgroundColor = .green
        return stack
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
    
    private lazy var squareViewWithImageView: UIView = {
        let view = UIView()
        view.addSubview(customImageView)
        return view
    }()
    
    // MARK: - View life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.backgroundColor = Utils.customBackgroundColor
        contentView.backgroundColor = .brown

        
        contentView.addSubview(squareViewWithImageView)
        contentView.addSubview(vertStackWithLabels)
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
        }
        
//        else {
//            // This is needed to take height of this label into account when system calculates automaticDimension for this cell
//            narratorsLabel.text = "Placeholder"
//            narratorsLabel.textColor = UIColor.clear
//        }
        
        if let image = book.coverImage {
            let resizedImage = image.resizeFor(targetHeight: AllTitlesTableViewCell.imageWidthAndHeight)
            
            if customImageView.bounds.width != image.size.width {
                customImageViewWidthAnchor.constant = resizedImage.size.width
            }
            customImageView.image = resizedImage
        }

    }
    
//    func configureFor(book: Book) {
//        bookTitleLabel.text = book.title
//        bookKindLabel.text = book.titleKind.rawValue
//
//        let authorNames = book.authors.map { $0.name }
//        let authorNamesString = authorNames.joined(separator: ", ")
//        authorsLabel.text = "By: \(authorNamesString)"
//
//        if let narrators = book.narrators {
//            let narratorNames = narrators.map { $0.name }
//            let narratorNamesString = narratorNames.joined(separator: ", ")
//            narratorsLabel.text = "With: \(narratorNamesString)"
//            narratorsLabel.textColor = UIColor.label
//        } else {
//            // This is needed to take height of this label into account when system calculates automaticDimension for this cell
//            narratorsLabel.text = "Placeholder"
//            narratorsLabel.textColor = UIColor.clear
//        }
//
//        if let image = book.coverImage {
//            let resizedImage = image.resizeFor(targetHeight: AllTitlesTableViewCell.imageWidthAndHeight)
//
//            if customImageView.bounds.width != image.size.width {
//                customImageViewWidthAnchor.constant = resizedImage.size.width
//            }
//            customImageView.image = resizedImage
//        }
//
//    }
    
    private func applyConstraints() {
        
        squareViewWithImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            squareViewWithImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
            squareViewWithImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            squareViewWithImageView.heightAnchor.constraint(equalToConstant: AllTitlesTableViewCell.imageWidthAndHeight),
            squareViewWithImageView.widthAnchor.constraint(equalToConstant: AllTitlesTableViewCell.imageWidthAndHeight)
        ])
        
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customImageView.topAnchor.constraint(equalTo: squareViewWithImageView.topAnchor),
            customImageView.heightAnchor.constraint(equalTo: squareViewWithImageView.heightAnchor),
            customImageView.centerXAnchor.constraint(equalTo: squareViewWithImageView.centerXAnchor),
        ])
        customImageViewWidthAnchor.isActive = true
        
        vertStackWithLabels.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vertStackWithLabels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AllTitlesTableViewCell.calculatedTopAndBottomPadding),
            vertStackWithLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AllTitlesTableViewCell.calculatedTopAndBottomPadding),
            vertStackWithLabels.leadingAnchor.constraint(equalTo: squareViewWithImageView.trailingAnchor, constant: Constants.cvPadding),
//            vertStackWithLabels.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor, constant: -Constants.cvPadding)
            vertStackWithLabels.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cvPadding)
        ])
    }
    
}
