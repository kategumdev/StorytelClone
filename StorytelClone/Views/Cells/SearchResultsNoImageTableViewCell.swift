//
//  SearchResultsNoImageTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 17/3/23.
//

import UIKit

class SearchResultsNoImageTableViewCell: SearchResultsTableViewCell {
    
    // MARK: - Static properties and methods
    static let identifier = "SearchResultsNoImageTableViewCell"
    static let viewWithRoundWidthAndHeight: CGFloat = SearchResultsTableViewCell.imageHeight
    static let minCellHeight = viewWithRoundWidthAndHeight
          
    static let calculatedTopAndBottomPadding: CGFloat = {
        // Not scaled font to calculate padding for default content size category
        let titleLabel = createTitleLabel(withScaledFont: false)
        let subtitleLabel = createSubtitleLabel(withScaledFont: false)
        titleLabel.text = "This is title"
        subtitleLabel.text = "This is subtitle"
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()

        let labelsHeight = titleLabel.bounds.height + subtitleLabel.bounds.height
        let padding = abs((minCellHeight - labelsHeight) / 2)
        return padding
    }()
    
    static func getEstimatedHeightForRow() -> CGFloat {
        let labelsHeight = calculateLabelsHeightWith(subtitleLabelNumber: 1)
        let rowHeight = labelsHeight + calculatedTopAndBottomPadding * 2
        return rowHeight
    }
    
    // MARK: - Instance properties
    private let titleLabel = SearchResultsTableViewCell.createTitleLabel()
    private let subtitleLabel = SearchResultsTableViewCell.createSubtitleLabel()
    
    private let symbolView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.label
        return imageView
    }()
        
    private lazy var roundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.clipsToBounds = true
        view.addSubview(symbolView)
        return view
    }()
    
    private lazy var viewWithRound: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(roundView)
        return view
    }()

    private lazy var vertStackWithLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        [titleLabel, subtitleLabel].forEach { stack.addArrangedSubview($0)}
        return stack
    }()
            
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(viewWithRound)
        contentView.addSubview(vertStackWithLabels)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        roundView.layer.cornerRadius = roundView.bounds.width / 2
    }
    
    // MARK: - Instance methods
    func configureFor(title: Title) {
        subtitleLabel.text = title.titleKind.rawValue
        
        if let author = title as? Author {
            titleLabel.text = author.name
            let config = UIImage.SymbolConfiguration(weight: .semibold)
            symbolView.image = UIImage(systemName: "pencil")?.withConfiguration(config)
        }
        
        if let narrator = title as? Narrator {
            titleLabel.text = narrator.name
            let config = UIImage.SymbolConfiguration(weight: .medium)
            symbolView.image = UIImage(systemName: "mic")?.withConfiguration(config)
        }
        
        if let tag  = title as? Tag {
            titleLabel.text = tag.tagTitle
            symbolView.image = UIImage(systemName: "number")
        }
        
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        viewWithRound.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewWithRound.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.commonHorzPadding),
            viewWithRound.widthAnchor.constraint(equalToConstant: SearchResultsNoImageTableViewCell.viewWithRoundWidthAndHeight),
            viewWithRound.heightAnchor.constraint(equalToConstant: SearchResultsNoImageTableViewCell.viewWithRoundWidthAndHeight),
            viewWithRound.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        roundView.translatesAutoresizingMaskIntoConstraints = false
        let roundViewConstant = SearchResultsNoImageTableViewCell.viewWithRoundWidthAndHeight * 0.14
        roundView.fillSuperview(withConstant: roundViewConstant)
        
        symbolView.translatesAutoresizingMaskIntoConstraints = false
        symbolView.fillSuperview(withConstant: roundViewConstant * 1.5)
        
        vertStackWithLabels.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vertStackWithLabels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultsNoImageTableViewCell.calculatedTopAndBottomPadding),
            vertStackWithLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SearchResultsNoImageTableViewCell.calculatedTopAndBottomPadding),
            vertStackWithLabels.leadingAnchor.constraint(equalTo: viewWithRound.trailingAnchor, constant: Constants.commonHorzPadding),
            vertStackWithLabels.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.commonHorzPadding),
        ])
        
        // Trigger layoutSubview() to set roundView.layer.cornerRadius
        layoutIfNeeded()
    }
    
}
