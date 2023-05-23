//
//  StorytellerBottomSheetTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/4/23.
//

import UIKit

enum BookDetailsBottomSheetCellKind: CaseIterable {
    case saveBook
    case markAsFinished
    case download
    case viewSeries
    case viewAuthors
    case viewNarrators
    case showMoreTitlesLikeThis
    case share
    
    var image: UIImage? {
        switch self {
        case .saveBook: return UIImage(systemName: "heart")
        case .markAsFinished: return UIImage(systemName: "checkmark")
        case .download: return UIImage(systemName: "arrow.down.circle")
        case .viewSeries: return UIImage(systemName: "rectangle.stack")
        case .viewAuthors: return UIImage(systemName: "pencil")
        case .viewNarrators: return UIImage(systemName: "mic")
        case .showMoreTitlesLikeThis: return UIImage(systemName: "square.grid.3x2")
        case .share: return UIImage(systemName: "paperplane")
        }
    }
    
}

class BottomSheetTableViewCell: UITableViewCell {

    static let identifier = "BottomSheetTableViewCell"

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectedBackgroundView = UIView() // avoid gray color when cell is selected
        backgroundColor = .clear
        tintColor = Utils.tintColor
        contentView.preservesSuperviewLayoutMargins = false
        
        var content = self.defaultContentConfiguration()
        let scaledFont = UIFont.createScaledFontWith(textStyle: .body, weight: .regular, basePointSize: 17, maxPointSize: 45)
//        let font = UIFont.preferredCustomFontWith(weight: .regular, size: 17)
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 45)
        content.textProperties.font = scaledFont
        content.textProperties.color = .label
        content.imageProperties.maximumSize = CGSize(width: 22, height: 22)
        content.imageProperties.tintColor = .label
//        content.axesPreservingSuperviewLayoutMargins = UIAxis.vertical
        content.axesPreservingSuperviewLayoutMargins = []
        content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: Constants.commonHorzPadding - 1, bottom: 0, trailing: Constants.commonHorzPadding)
        self.contentConfiguration = content
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureWith(storyteller: Storyteller) {
        guard var content = self.contentConfiguration as? UIListContentConfiguration else { return }
        content.image = UIImage(systemName: "person.circle.fill")
        content.imageProperties.tintColor = UIColor.label.withAlphaComponent(0.8)
        content.text = storyteller.name
        self.contentConfiguration = content
    }

    func configureFor(book: Book, bookDetailsBottomSheetCellKind: BookDetailsBottomSheetCellKind) {
        guard var content = self.contentConfiguration as? UIListContentConfiguration else { return }
        let bookDetailsCell = bookDetailsBottomSheetCellKind
        content.image = bookDetailsCell.image
                    
        var text = ""
        switch bookDetailsCell {
        case .saveBook:
            text = book.isAddedToBookshelf ? "Remove from bookshelf" : "Add to bookshelf"
            let newImageName = book.isAddedToBookshelf ? "heart.fill" : "heart"
            content.image = UIImage(systemName: newImageName)
            let color = book.isAddedToBookshelf ? Utils.tintColor : .label
            content.imageProperties.tintColor = color
            
        case .markAsFinished:
            let color: UIColor = book.isFinished ? .label : Utils.unactiveElementColor
            content.textProperties.color = color
            content.imageProperties.tintColor = color
            text = "Mark as finished"
            
        case .download:
            let color: UIColor = book.isDownloaded ? .label : Utils.unactiveElementColor
            content.textProperties.color = color
            content.imageProperties.tintColor = color
            text = "Download"
            
        case .viewSeries: text = "View series"
        case .viewAuthors: text = book.authors.count == 1 ? "View author" : "View authors"
        case .viewNarrators: text = book.narrators.count == 1 ? "View narrator" : "View narrators"
        case .showMoreTitlesLikeThis: text = "Show more titles like this"
        case .share: text = "Share"
        }
        
        content.text = text
        self.contentConfiguration = content
    }

}
