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
    
    static let heightForRow: CGFloat =
    calculatedButtonHeight + Constants.topPaddingForPosterAndLargeRectCoversCells
        
    static let calculatedButtonWidth: CGFloat =
    UIScreen.main.bounds.size.width - (Constants.commonHorzPadding * 2)
    
    static let calculatedButtonHeight: CGFloat = {
        let height = round(calculatedButtonWidth + (calculatedButtonWidth / 6))
        return height
    }()
    
    // MARK: - Instance property
    private let dimmedAnimationButton = DimmedAnimationButton()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureFor(book: Book, withCallback callback: @escaping DimmedAnimationBtnDidTapCallback) {
        dimmedAnimationButton.kind = .toPushBookVcWith(book)
        dimmedAnimationButton.didTapCallback = callback
        dimmedAnimationButton.configuration?.background.image = book.coverImage
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        contentView.backgroundColor = UIColor.customBackgroundColor
        contentView.addSubview(dimmedAnimationButton)
        dimmedAnimationButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
        applyConstraints()
    }
    
    private func applyConstraints() {
        dimmedAnimationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedAnimationButton.widthAnchor.constraint(
                equalToConstant: PosterTableViewCell.calculatedButtonWidth),
            dimmedAnimationButton.heightAnchor.constraint(
                equalToConstant: PosterTableViewCell.calculatedButtonHeight),
            dimmedAnimationButton.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.topPaddingForPosterAndLargeRectCoversCells),
            dimmedAnimationButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}
