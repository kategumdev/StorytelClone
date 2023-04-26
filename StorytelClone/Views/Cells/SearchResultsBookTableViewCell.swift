//
//  ResultsTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 15/3/23.
//

import UIKit

class SearchResultsBookTableViewCell: SearchResultsTableViewCell {

    // MARK: - Static properties and methods
    static let identifier = "ResultsTableViewCell"
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
    
    // MARK: - Instance properties
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
    
    private lazy var customImageViewWidthAnchor = customImageView.widthAnchor.constraint(equalToConstant: SearchResultsTableViewCell.imageHeight)
    
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
    
    private var book: Book?
    
    var detailButtonDidTapCallback: (Book) -> () = {_ in}
//    var detailButtonDidTapCallback: () -> () = {}
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(squareViewWithImageView)
        contentView.addSubview(vertStackWithLabels)
        contentView.addSubview(detailButton)
        addDetailButtonAction()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            customImageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        }
    }
    
    // MARK: - Instance methods
    func configureFor(book: Book) {
        self.book = book
        
        bookTitleLabel.text = book.title
        bookKindLabel.text = book.titleKind.rawValue

        let authorNames = book.authors.map { $0.name }
        let authorNamesString = authorNames.joined(separator: ", ")
        authorsLabel.text = "By: \(authorNamesString)"
        
        if !book.narrators.isEmpty {
            let narratorNames = book.narrators.map { $0.name }
            let narratorNamesString = narratorNames.joined(separator: ", ")
            narratorsLabel.text = "With: \(narratorNamesString)"
            narratorsLabel.textColor = UIColor.label
        } else {
            // This is needed to take height of this label into account when system calculates automaticDimension for this cell
            narratorsLabel.text = "Placeholder"
            narratorsLabel.textColor = UIColor.clear
        }
        
        if let image = book.coverImage {
            let resizedImage = image.resizeFor(targetHeight: SearchResultsTableViewCell.imageHeight)
            
            if customImageView.bounds.width != image.size.width {
                customImageViewWidthAnchor.constant = resizedImage.size.width
            }
            customImageView.image = resizedImage
        }

    }
    
    // MARK: - Helper methods
    private func addDetailButtonAction() {
        detailButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self, let book = self.book else { return }
//            self.detailButtonDidTapCallback(self.book)
            self.detailButtonDidTapCallback(book)
        }), for: .touchUpInside)
    }
    
    private func applyConstraints() {
        squareViewWithImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            squareViewWithImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.commonHorzPadding),
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
            detailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.commonHorzPadding),
            detailButton.widthAnchor.constraint(equalToConstant: 30),
            detailButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        vertStackWithLabels.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vertStackWithLabels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultsBookTableViewCell.calculatedTopAndBottomPadding),
            vertStackWithLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SearchResultsBookTableViewCell.calculatedTopAndBottomPadding),
            vertStackWithLabels.leadingAnchor.constraint(equalTo: squareViewWithImageView.trailingAnchor, constant: Constants.commonHorzPadding),
            vertStackWithLabels.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor, constant: -Constants.commonHorzPadding)
        ])
    }

}
