//
//  SearchResultsNoImageTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 17/3/23.
//

import UIKit

class SearchResultsNoImageTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultsNoImageTableViewCell"
    
    static let viewWithRoundWidthAndHeight: CGFloat = SearchResultsBookTableViewCell.imageHeight
    static let minCellHeight = viewWithRoundWidthAndHeight
          
    static let calculatedTopAndBottomPadding: CGFloat = {
        let titleLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45, withScaledFont: false)
        let subtitleLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38, withScaledFont: false)
        
        titleLabel.text = "This is title"
        subtitleLabel.text = "This is subtitle"
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()

        let labelsHeight = titleLabel.bounds.height + subtitleLabel.bounds.height
        let padding = abs((minCellHeight - labelsHeight) / 2)
        return padding
    }()
    
    static func getEstimatedHeightForRow() -> CGFloat {
        let titleLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45)
        let subtitleLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38)

        titleLabel.text = "This is title"
        subtitleLabel.text = "This is subtitle"
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()

        let labelsHeight = titleLabel.bounds.height + subtitleLabel.bounds.height
        let rowHeight = labelsHeight + calculatedTopAndBottomPadding * 2
        return rowHeight
    }
    
    // Title model object (Storyteller or Tag)
    var title: Title?
    
    private let titleLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45)
    private let subtitleLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38)
    
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
    
//    private var firstTime = true
    
    private var padding: CGFloat = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Utils.customBackgroundColor
        contentView.addSubview(viewWithRound)
        contentView.addSubview(vertStackWithLabels)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundView.layer.cornerRadius = roundView.bounds.width / 2
    }
    
    func configureFor(title: Title) {
        self.title = title
        subtitleLabel.text = title.titleKind.rawValue
        
        if let storyteller = title as? Storyteller {
            titleLabel.text = storyteller.name
            
            if storyteller.titleKind == .author {
                let config = UIImage.SymbolConfiguration(weight: .semibold)
                symbolView.image = UIImage(systemName: "pencil")?.withConfiguration(config)
            } else {
                let config = UIImage.SymbolConfiguration(weight: .medium)
                symbolView.image = UIImage(systemName: "mic")?.withConfiguration(config)
            }
        }
        
        if let tag  = title as? Tag {
            titleLabel.text = tag.tagTitle
            symbolView.image = UIImage(systemName: "number")
        }
    }
    
    private func applyConstraints() {
        viewWithRound.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewWithRound.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
            viewWithRound.widthAnchor.constraint(equalToConstant: SearchResultsNoImageTableViewCell.viewWithRoundWidthAndHeight),
            viewWithRound.heightAnchor.constraint(equalToConstant: SearchResultsNoImageTableViewCell.viewWithRoundWidthAndHeight),
            viewWithRound.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
//        roundView.translatesAutoresizingMaskIntoConstraints = false
//        roundView.fillSuperview(withConstant: SearchResultsNoImageTableViewCell.minTopAndBottomPadding)
//
//        symbolView.translatesAutoresizingMaskIntoConstraints = false
//        symbolView.fillSuperview(withConstant: SearchResultsNoImageTableViewCell.minTopAndBottomPadding * 1.5)
        
        roundView.translatesAutoresizingMaskIntoConstraints = false
        let roundViewConstant = SearchResultsNoImageTableViewCell.viewWithRoundWidthAndHeight * 0.14
        roundView.fillSuperview(withConstant: roundViewConstant)
        
        symbolView.translatesAutoresizingMaskIntoConstraints = false
        symbolView.fillSuperview(withConstant: roundViewConstant * 1.5)
        
        vertStackWithLabels.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vertStackWithLabels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultsNoImageTableViewCell.calculatedTopAndBottomPadding),
            vertStackWithLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SearchResultsNoImageTableViewCell.calculatedTopAndBottomPadding),
            vertStackWithLabels.leadingAnchor.constraint(equalTo: viewWithRound.trailingAnchor, constant: Constants.cvPadding),
            vertStackWithLabels.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cvPadding),
        ])
        
        // Trigger layoutSubview() to set roundView.layer.cornerRadius
        layoutIfNeeded()
    }
    
}
