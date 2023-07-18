//
//  ScopeSeriesTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 20/3/23.
//

import UIKit

class ScopeSeriesTableViewCell: BaseScopeTableViewCell {
    // MARK: - Static properties and methods
    static let identifier = "ScopeSeriesTableViewCell"
    static let minTopBottomPadding = minTopAndBottomPadding - 2
    static let oneTransparentImageVisiblePartHeight: CGFloat = 4
    static let minCellHeight: CGFloat =
    imageHeight + minTopBottomPadding * 2 + oneTransparentImageVisiblePartHeight * 2
    
    static func getEstimatedHeightForRow() -> CGFloat {
        let labelsHeight = calculateLabelsHeightWith(subtitleLabelNumber: 3)
        let rowHeight = labelsHeight + calculatedTopAndBottomPadding * 2
        return rowHeight
    }
    
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
    
    // MARK: - Instance properties
    lazy var vertStackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        let views = [seriesTitleLabel, titleKindLabel, languageLabel, authorsLabel]
        views.forEach { stack.addArrangedSubview($0)}
        return stack
    }()
    
    private let seriesTitleLabel = createTitleLabel()
    private let titleKindLabel = createSubtitleLabel()
    private let languageLabel = createSubtitleLabel()
    private let authorsLabel = createSubtitleLabel()
    
    private lazy var viewWithImageViews: UIView = {
        let view = UIView()
        view.addSubview(transparentImageViewOne)
        view.addSubview(transparentImageViewTwo)
        view.addSubview(mainImageView)
        return view
    }()
    
    private let transparentImageViewOne = createImageView()
    private let transparentImageViewTwo = createImageView()
    private let transparentImageOneHeight = imageHeight - oneTransparentImageVisiblePartHeight * 4
    private let transparentImageTwoHeight = imageHeight - oneTransparentImageVisiblePartHeight * 2
    
    private let mainImageView = createImageView()
    private lazy var mainImageViewWidthAnchor =
    mainImageView.widthAnchor.constraint(equalToConstant: BaseScopeTableViewCell.imageHeight)
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance method
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
                mainImageView.layer.cornerRadius = BaseScopeTableViewCell.cornerRadius
                transparentImageViewOne.layer.cornerRadius = BaseScopeTableViewCell.cornerRadius
                transparentImageViewTwo.layer.cornerRadius = BaseScopeTableViewCell.cornerRadius
            }
        }
        
        // Resize and set mainImage
        if let image = series.coverImage {
            let resizedImage = image.resizeFor(targetHeight: BaseScopeTableViewCell.imageHeight)
            
            if mainImageView.bounds.width != image.size.width {
                mainImageViewWidthAnchor.constant = resizedImage.size.width
            }
            mainImageView.image = resizedImage
        }
        
        // Resize and set transparentImageOne
        if let image = series.coverImage {
            let resizedTransparentImage = image.resizeFor(
                targetHeight: transparentImageOneHeight,
                andSetAlphaTo: 0.4)
            transparentImageViewOne.image = resizedTransparentImage
        }
        
        // Resize and set transparentImageTwo
        if let image = series.coverImage {
            let resizedTransparentImage = image.resizeFor(
                targetHeight: transparentImageTwoHeight,
                andSetAlphaTo: 0.7)
            transparentImageViewTwo.image = resizedTransparentImage
        }
    }
    
    // MARK: - Helper methods
    private func setupUI() {
        contentView.addSubview(viewWithImageViews)
        contentView.addSubview(vertStackWithLabels)
        applyConstraints()
    }
    
    private func applyConstraints() {
        viewWithImageViews.translatesAutoresizingMaskIntoConstraints = false
        let height =
        BaseScopeTableViewCell.imageHeight + ScopeSeriesTableViewCell.oneTransparentImageVisiblePartHeight * 2
        NSLayoutConstraint.activate([
            viewWithImageViews.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.commonHorzPadding),
            viewWithImageViews.widthAnchor.constraint(equalToConstant: BaseScopeTableViewCell.squareImageWidth),
            viewWithImageViews.heightAnchor.constraint(equalToConstant: height),
            viewWithImageViews.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainImageView.bottomAnchor.constraint(equalTo: viewWithImageViews.bottomAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: BaseScopeTableViewCell.imageHeight),
            mainImageView.centerXAnchor.constraint(equalTo: viewWithImageViews.centerXAnchor),
        ])
        mainImageViewWidthAnchor.isActive = true
        
        transparentImageViewOne.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            transparentImageViewOne.topAnchor.constraint(equalTo: viewWithImageViews.topAnchor),
            transparentImageViewOne.centerXAnchor.constraint(equalTo: viewWithImageViews.centerXAnchor),
            transparentImageViewOne.heightAnchor.constraint(equalToConstant: transparentImageOneHeight),
            transparentImageViewOne.widthAnchor.constraint(
                equalTo: mainImageView.heightAnchor,
                constant: -ScopeSeriesTableViewCell.oneTransparentImageVisiblePartHeight * 4)
        ])
        
        transparentImageViewTwo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            transparentImageViewTwo.topAnchor.constraint(
                equalTo: viewWithImageViews.topAnchor,
                constant: ScopeSeriesTableViewCell.oneTransparentImageVisiblePartHeight),
            transparentImageViewTwo.centerXAnchor.constraint(equalTo: viewWithImageViews.centerXAnchor),
            transparentImageViewTwo.heightAnchor.constraint(equalToConstant: transparentImageTwoHeight),
            transparentImageViewTwo.widthAnchor.constraint(
                equalTo: mainImageView.heightAnchor,
                constant: -ScopeSeriesTableViewCell.oneTransparentImageVisiblePartHeight * 2)
        ])
        
        vertStackWithLabels.translatesAutoresizingMaskIntoConstraints = false
        let topConstant = ScopeSeriesTableViewCell.calculatedTopAndBottomPadding / 2 +
        ScopeSeriesTableViewCell.oneTransparentImageVisiblePartHeight
        let bottomConstant = ScopeSeriesTableViewCell.calculatedTopAndBottomPadding / 2 -
        ScopeSeriesTableViewCell.oneTransparentImageVisiblePartHeight
        NSLayoutConstraint.activate([
            vertStackWithLabels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topConstant),
            vertStackWithLabels.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -bottomConstant),
            vertStackWithLabels.leadingAnchor.constraint(
                equalTo: viewWithImageViews.trailingAnchor,
                constant: Constants.commonHorzPadding),
            vertStackWithLabels.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.commonHorzPadding)
        ])
    }
}
