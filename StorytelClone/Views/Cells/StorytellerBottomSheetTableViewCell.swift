//
//  StorytellerBottomSheetTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/4/23.
//

import UIKit

class StorytellerBottomSheetTableViewCell: UITableViewCell {
    
    static let identifier = "StorytellerBottomSheetTableViewCell"
//    static let rowHeight: CGFloat = 40
    
    // MARK: - Instance properties
    
    let customTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredCustomFontWith(weight: .regular, size: 17)
        return label
    }()

    let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.label.withAlphaComponent(0.8)
        imageView.image = UIImage(systemName: "person.circle.fill")
        return imageView
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectedBackgroundView = UIView() // avoid gray color when cell is selected
        backgroundColor = .clear
        contentView.addSubview(customImageView)
        contentView.addSubview(customTitleLabel)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureWith(storyteller: Title) {
        var text = ""
        if let author = storyteller as? Author {
            text = author.name
        }
        
        if let narrator = storyteller as? Narrator {
            text = narrator.name
        }
        customTitleLabel.text = text
    }
    
    func configureFor(book: Book, ellipsisButtonCell: EllipsisButtonCell) {
//        print("ellipsisButtonCell \(ellipsisButtonCell.rawValue)")
        let imageName = ellipsisButtonCell.rawValue
        customImageView.image = UIImage(systemName: imageName)
        
        var text = ""
        switch ellipsisButtonCell {
        case .addRemoveToBookShelf:
            text = book.isAddedToBookshelf ? "Remove from bookshelf" : "Add to bookshelf"
        case .markAsFinished:
            text = "Mark as finished"
        case .download:
            text = "Download"
        case .viewSeries:
            text = "View series"
        case .viewAuthors:
            text = book.authors.count == 1 ? "View author" : "View authors"
        case .viewNarrators:
            if let narrators = book.narrators {
                text = narrators.count == 1 ? "View narrator" : "View narrators"
            }
        case .showMoreTitlesLikeThis:
            text = "Show more titles like this"
        case .share:
            text = "Share"
        }
        
        customTitleLabel.text = text
    }
    
    // MARK: - Helper methods
//    private func update(labelText: String, imageName: String) {
//        customTitleLabel.text = labelText
//        customImageView.image = UIImage(systemName: imageName)
//    }
    
    private func applyConstraints() {
        let constant: CGFloat = 22
        
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customImageView.heightAnchor.constraint(equalToConstant: constant),
            customImageView.widthAnchor.constraint(equalToConstant: constant),
            customImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cvPadding)
        ])
        
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customTitleLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: Constants.cvPadding - 4),
            customTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.cvPadding)
        ])
    }
}
