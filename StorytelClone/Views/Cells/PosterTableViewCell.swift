//
//  PosterTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

class PosterTableViewCell: UITableViewCell {
    
    static let identifier = "PosterTableViewCell"
    
    static let topPadding: CGFloat = 10
    
    static let calculatedWidth: CGFloat = UIScreen.main.bounds.size.width - (Constants.cvPadding * 2)
    
    static let calculatedHeightForRow: CGFloat = calculatedHeight + topPadding
    
    static let calculatedHeight: CGFloat = {
        let height = round(calculatedWidth + (calculatedWidth / 6))
        return height
    }()
    
    // MARK: - Instance properties
    lazy var posterButton: DimViewAnimationButton = {
        let button = DimViewAnimationButton(scaleForTransform: 0.98)
        return button
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    func configureFor(book: Book, withCallbackForButton callback: @escaping BookButtonCallbackClosure) {
        posterButton.book = book
        posterButton.callbackClosure = callback
    }
    
    private func applyConstraints() {
        posterButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterButton.widthAnchor.constraint(equalToConstant: PosterTableViewCell.calculatedWidth),
            posterButton.heightAnchor.constraint(equalToConstant: PosterTableViewCell.calculatedHeight),
            posterButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: PosterTableViewCell.topPadding),
            posterButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}
