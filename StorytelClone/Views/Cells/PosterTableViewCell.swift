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
        
    static let calculatedWidth: CGFloat = UIScreen.main.bounds.size.width - (Constants.cvPadding * 2)
    static let calculatedHeightForRow: CGFloat = calculatedHeight + Constants.posterAndLargeCoversCellTopPadding
    
    static let calculatedHeight: CGFloat = {
        let height = round(calculatedWidth + (calculatedWidth / 6))
        return height
    }()
    
    // MARK: - Instance properties
    private let posterButton = DimViewCellButton()
    
//    private lazy var dimViewForButtonAnimation: UIView = {
//        let view = UIView()
//        view.backgroundColor = Utils.customBackgroundColor
//        return view
//    }()
    
    // MARK: - View life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Utils.customBackgroundColor
        contentView.addSubview(posterButton)
//        contentView.addSubview(dimViewForButtonAnimation)
        
//        addButtonUpdateHandler()
//        posterButton.addConfigurationUpdateHandlerWith(viewToTransform: self, viewToChangeAlpha: dimViewForButtonAnimation)
        posterButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    func configureFor(book: Book, withCallbackForButton callback: @escaping ButtonCallback) {
        posterButton.book = book
        posterButton.callback = callback
        
        posterButton.configuration?.background.image = book.coverImage
    }
    
    private func applyConstraints() {
//        dimViewForButtonAnimation.translatesAutoresizingMaskIntoConstraints = false
//        dimViewForButtonAnimation.fillSuperview()
        
        posterButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterButton.widthAnchor.constraint(equalToConstant: PosterTableViewCell.calculatedWidth),
            posterButton.heightAnchor.constraint(equalToConstant: PosterTableViewCell.calculatedHeight),
            posterButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.posterAndLargeCoversCellTopPadding),
            posterButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}
