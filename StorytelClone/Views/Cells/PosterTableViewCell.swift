//
//  PosterTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

class PosterTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    static let identifier = "PosterTableViewCell"
        
    static let calculatedWidth: CGFloat = UIScreen.main.bounds.size.width - (Constants.commonHorzPadding * 2)
    static let calculatedHeightForRow: CGFloat = calculatedHeight + Constants.posterAndLargeCoversCellTopPadding
    
    static let calculatedHeight: CGFloat = {
        let height = round(calculatedWidth + (calculatedWidth / 6))
        return height
    }()
    
    // MARK: - Instance properties
    private let dimmedAnimationButton = DimmedAnimationButton()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.customBackgroundColor
        contentView.addSubview(dimmedAnimationButton)
        dimmedAnimationButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureFor(book: Book, withCallback callback: @escaping DimmedAnimationButtonDidTapCallback) {
        dimmedAnimationButton.kind = .toPushBookVcWith(book)
        dimmedAnimationButton.didTapCallback = callback
        dimmedAnimationButton.configuration?.background.image = book.coverImage
    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        dimmedAnimationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedAnimationButton.widthAnchor.constraint(equalToConstant: PosterTableViewCell.calculatedWidth),
            dimmedAnimationButton.heightAnchor.constraint(equalToConstant: PosterTableViewCell.calculatedHeight),
            dimmedAnimationButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.posterAndLargeCoversCellTopPadding),
            dimmedAnimationButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}
