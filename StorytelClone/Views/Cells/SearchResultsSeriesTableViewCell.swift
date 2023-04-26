//
//  SearchResultsSeriesTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 20/3/23.
//

import UIKit

class SearchResultsSeriesTableViewCell: SearchResultsTableViewCell {
    
    // MARK: - Static properties and methods
    static let identifier = "SearchResultsSeriesTableViewCell"
    static let minTopBottomPadding = SearchResultsTableViewCell.minTopAndBottomPadding - 2
    static let oneTransparentImageVisiblePartHeight: CGFloat = 4
    static let minCellHeight: CGFloat = imageHeight + minTopBottomPadding * 2 + oneTransparentImageVisiblePartHeight * 2

    static let calculatedTopAndBottomPadding: CGFloat = {
        // Not scaled font to calculate padding for default content size category
        let titleLabel = createTitleLabel(withScaledFont: false)
        let subtitleLabel = createSubtitleLabel(withScaledFont: false)
        titleLabel.text = "This is title"
        subtitleLabel.text = "This is subtitle"
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        
        let labelsHeight = titleLabel.bounds.height + (subtitleLabel.bounds.height * 3)
        let padding = abs(minCellHeight - labelsHeight)
        return padding
    }()
    
    static func getEstimatedHeightForRow() -> CGFloat {
        let labelsHeight = calculateLabelsHeightWith(subtitleLabelNumber: 3)
        let rowHeight = labelsHeight + calculatedTopAndBottomPadding * 2
        return rowHeight
    }
    
    // MARK: - Instance properties
    private let seriesTitleLabel = SearchResultsTableViewCell.createTitleLabel()
    private let titleKindLabel = SearchResultsTableViewCell.createSubtitleLabel()
    private let languageLabel = SearchResultsTableViewCell.createSubtitleLabel()
    private let authorsLabel = SearchResultsTableViewCell.createSubtitleLabel()
    
    lazy var vertStackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        [seriesTitleLabel, titleKindLabel, languageLabel, authorsLabel].forEach { stack.addArrangedSubview($0)}
        return stack
    }()
    
    private let mainImageView = SearchResultsTableViewCell.createImageView()
    private lazy var mainImageViewWidthAnchor = mainImageView.widthAnchor.constraint(equalToConstant: SearchResultsTableViewCell.imageHeight)
    
    private let transparentImageViewOne = SearchResultsTableViewCell.createImageView()
    private let transparentImageViewTwo = SearchResultsTableViewCell.createImageView()
    private let transparentImageOneHeight = SearchResultsTableViewCell.imageHeight - SearchResultsSeriesTableViewCell.oneTransparentImageVisiblePartHeight * 4
    private let transparentImageTwoHeight = SearchResultsTableViewCell.imageHeight - SearchResultsSeriesTableViewCell.oneTransparentImageVisiblePartHeight * 2
    
    private lazy var viewWithImageViews: UIView = {
        let view = UIView()
        view.addSubview(transparentImageViewOne)
        view.addSubview(transparentImageViewTwo)
        view.addSubview(mainImageView)
        return view
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(viewWithImageViews)
        contentView.addSubview(vertStackWithLabels)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureFor(series: Series) {
        seriesTitleLabel.text = series.title
        titleKindLabel.text = series.titleKind.rawValue
        languageLabel.text = series.language.rawValue

        let authorNames = series.authors.map { $0.name }
        let authorNamesString = authorNames.joined(separator: ", ")
        authorsLabel.text = "By: \(authorNamesString)"
        
        if let image = series.coverImage {
            if image.size.width != image.size.height {
                mainImageView.layer.cornerRadius = 0
                transparentImageViewOne.layer.cornerRadius = 0
                transparentImageViewTwo.layer.cornerRadius = 0
            } else {
                mainImageView.layer.cornerRadius = SearchResultsTableViewCell.cornerRadius
                transparentImageViewOne.layer.cornerRadius = SearchResultsTableViewCell.cornerRadius
                transparentImageViewTwo.layer.cornerRadius = SearchResultsTableViewCell.cornerRadius
            }
        }
        
        // Resize and set mainImage
        if let image = series.coverImage {
            let resizedImage = image.resizeFor(targetHeight: SearchResultsTableViewCell.imageHeight)
            
            if mainImageView.bounds.width != image.size.width {
                mainImageViewWidthAnchor.constant = resizedImage.size.width
            }
            mainImageView.image = resizedImage
        }
        
        // Resize and set transparentImageOne
        if let image = series.coverImage {
            let resizedTransparentImage = image.resizeFor(targetHeight: transparentImageOneHeight, andSetAlphaTo: 0.4)
            transparentImageViewOne.image = resizedTransparentImage
        }
        
        // Resize and set transparentImageTwo
        if let image = series.coverImage {
            let resizedTransparentImage = image.resizeFor(targetHeight: transparentImageTwoHeight, andSetAlphaTo: 0.7)
            transparentImageViewTwo.image = resizedTransparentImage
        }

    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        viewWithImageViews.translatesAutoresizingMaskIntoConstraints = false
        let height = SearchResultsTableViewCell.imageHeight + SearchResultsSeriesTableViewCell.oneTransparentImageVisiblePartHeight * 2
        NSLayoutConstraint.activate([
            viewWithImageViews.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.commonHorzPadding),
            viewWithImageViews.widthAnchor.constraint(equalToConstant: SearchResultsTableViewCell.squareImageWidth),
            viewWithImageViews.heightAnchor.constraint(equalToConstant: height),
            viewWithImageViews.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainImageView.bottomAnchor.constraint(equalTo: viewWithImageViews.bottomAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: SearchResultsTableViewCell.imageHeight),
            mainImageView.centerXAnchor.constraint(equalTo: viewWithImageViews.centerXAnchor),
        ])
        mainImageViewWidthAnchor.isActive = true
        
        transparentImageViewOne.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            transparentImageViewOne.topAnchor.constraint(equalTo: viewWithImageViews.topAnchor),
            transparentImageViewOne.centerXAnchor.constraint(equalTo: viewWithImageViews.centerXAnchor),
            transparentImageViewOne.heightAnchor.constraint(equalToConstant: transparentImageOneHeight),
            transparentImageViewOne.widthAnchor.constraint(equalTo: mainImageView.heightAnchor, constant: -SearchResultsSeriesTableViewCell.oneTransparentImageVisiblePartHeight * 4)
        ])
        
        transparentImageViewTwo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            transparentImageViewTwo.topAnchor.constraint(equalTo: viewWithImageViews.topAnchor, constant: SearchResultsSeriesTableViewCell.oneTransparentImageVisiblePartHeight),
            transparentImageViewTwo.centerXAnchor.constraint(equalTo: viewWithImageViews.centerXAnchor),
            transparentImageViewTwo.heightAnchor.constraint(equalToConstant: transparentImageTwoHeight),
            transparentImageViewTwo.widthAnchor.constraint(equalTo: mainImageView.heightAnchor, constant: -SearchResultsSeriesTableViewCell.oneTransparentImageVisiblePartHeight * 2)
        ])
        
        vertStackWithLabels.translatesAutoresizingMaskIntoConstraints = false
        let topConstant = SearchResultsSeriesTableViewCell.calculatedTopAndBottomPadding / 2 + SearchResultsSeriesTableViewCell.oneTransparentImageVisiblePartHeight
        let bottomConstant = SearchResultsSeriesTableViewCell.calculatedTopAndBottomPadding / 2 - SearchResultsSeriesTableViewCell.oneTransparentImageVisiblePartHeight
        NSLayoutConstraint.activate([
            vertStackWithLabels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topConstant),
            vertStackWithLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -bottomConstant),
            vertStackWithLabels.leadingAnchor.constraint(equalTo: viewWithImageViews.trailingAnchor, constant: Constants.commonHorzPadding),
            vertStackWithLabels.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.commonHorzPadding)
        ])
    }

}
