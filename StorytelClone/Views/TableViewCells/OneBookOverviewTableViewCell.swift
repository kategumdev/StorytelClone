//
//  OneBookOverviewTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 6/3/23.
//

import UIKit

class OneBookOverviewTableViewCell: UITableViewCell {
    // MARK: - Static properties and methods
    static let identifier = "OneBookOverviewTableViewCell"

    static func calculateHeightForRow(withBook book: Book?) -> CGFloat {
        guard let book = book else { return 300 }
        let container = OneBookOverviewCellSubviewsContainer()
        container.configureFor(book: book)
        let height = container.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    
    // MARK: - Instance properties
    private let subviewsContainer = OneBookOverviewCellSubviewsContainer()
    var saveBookButtonDidTapCallback: SaveBookButtonDidTapCallback = {_ in}
        
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.customBackgroundColor        
        contentView.addSubview(subviewsContainer)
        subviewsContainer.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("OneBookOverviewTableViewCell is not configured to be instantiated from storyboard")
    }
    
    // MARK: - Instance methods
    func configureFor(
        book: Book?,
        dimmedAnimationButtonCallback: @escaping DimmedAnimationBtnDidTapCallback,
        callbackForSaveButton: @escaping SaveBookButtonDidTapCallback
    ) {
        subviewsContainer.configureFor(book: book)
        
        if book != nil {
            subviewsContainer.dimmedAnimationButton.didTapCallback = dimmedAnimationButtonCallback
            subviewsContainer.saveBookButtonDidTapCallback = callbackForSaveButton
        }
    }

}
