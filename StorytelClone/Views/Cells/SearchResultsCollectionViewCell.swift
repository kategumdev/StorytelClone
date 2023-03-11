//
//  SearchResultsCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 11/3/23.
//

import UIKit

class SearchResultsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchResultsCollectionViewCell"
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredCustomFontWith(weight: .semibold, size: 19)
        label.textColor = UIColor.label
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Utils.customBackgroundColor
        contentView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
