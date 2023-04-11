//
//  BookWithOverviewTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 6/3/23.
//

import UIKit

class BookWithOverviewTableViewCell: UITableViewCell {
    
    // MARK: - Static properties and methods
    static let identifier = "BookWithOverviewTableViewCell"
    
    static func calculateHeightForRow(withBook book: Book) -> CGFloat {
        let container = BookWithOverviewCellSubviewsContainer()
        container.configureFor(book: book)
        let height = container.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    
    // MARK: - Instance properties
    private let containerWithSubviews = BookWithOverviewCellSubviewsContainer()
        
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Utils.customBackgroundColor        
        contentView.addSubview(containerWithSubviews)
        containerWithSubviews.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("BookCollectionViewCell is not configured to be instantiated from storyboard")
    }
    
    // MARK: - Instance methods
    func configureFor(book: Book, withCallbackForButton callback: @escaping ButtonCallback) {
        containerWithSubviews.configureFor(book: book)
        containerWithSubviews.bookOverviewButton.callback = callback
    }
    
}
