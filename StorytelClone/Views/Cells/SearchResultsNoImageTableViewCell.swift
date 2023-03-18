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
    
    static let topAndBottomPadding: CGFloat = {
        let titleLabel = UILabel.createLabel(withFont: Utils.sectionTitleFont, maximumPointSize: 45)
        let subtitleLabel = UILabel.createLabel(withFont: Utils.sectionSubtitleFont, maximumPointSize: 38)
        titleLabel.text = "This is title"
        subtitleLabel.text = "This is subtitle"
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        
        let labelsHeight = titleLabel.bounds.height + subtitleLabel.bounds.height
        
//        let padding = ceil((viewWithRoundWidthAndHeight - labelsHeight) / 2)
        let padding = (viewWithRoundWidthAndHeight - labelsHeight) / 2
        print("padding + labelsHeight = \(padding * 2 + labelsHeight)")
        print("viewWithRoundWidthAndHeight: \(viewWithRoundWidthAndHeight)")
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
        
        let rowHeight = labelsHeight + topAndBottomPadding * 2
        return rowHeight
    }
        
//    var storyteller: Storyteller?
//    var hashtag: Tag?
    
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
//        view.backgroundColor = .green
        view.backgroundColor = .clear
        view.addSubview(roundView)
        return view
    }()

    lazy var vertStackWithLabels: UIStackView = {
        let stack = UIStackView()
//        stack.backgroundColor = .magenta
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        [titleLabel, subtitleLabel].forEach { stack.addArrangedSubview($0)}
        return stack
    }()
    
    private var firstTime = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Utils.customBackgroundColor
//        contentView.backgroundColor = .blue
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

    func configureFor(storyteller: Storyteller) {
        titleLabel.text = storyteller.name
        subtitleLabel.text = storyteller.titleKind.rawValue
        
        if storyteller.titleKind == .author {
            let config = UIImage.SymbolConfiguration(weight: .semibold)
            symbolView.image = UIImage(systemName: "pencil")?.withConfiguration(config)
        } else {
            let config = UIImage.SymbolConfiguration(weight: .medium)
            symbolView.image = UIImage(systemName: "mic")?.withConfiguration(config)
        }
    }
    
    func configureFor(tag: Tag) {
        titleLabel.text = tag.title
        subtitleLabel.text = tag.titleKind.rawValue
        symbolView.image = UIImage(systemName: "number")

    }
    
    private func applyConstraints() {
        viewWithRound.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewWithRound.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding),
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
            vertStackWithLabels.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultsNoImageTableViewCell.topAndBottomPadding),
            vertStackWithLabels.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SearchResultsNoImageTableViewCell.topAndBottomPadding),
            vertStackWithLabels.leadingAnchor.constraint(equalTo: viewWithRound.trailingAnchor, constant: Constants.cvPadding),
            vertStackWithLabels.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cvPadding),
        ])
        
        // Trigger layoutSubview() to set roundView.layer.cornerRadius
        layoutIfNeeded()
    }
    
}
