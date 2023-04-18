//
//  StorytellerBottomSheetTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/4/23.
//

import UIKit

class StorytellerBottomSheetTableViewCell: UITableViewCell {
    
    static let identifier = "StorytellerBottomSheetTableViewCell"
    
    // MARK: - Instance properties
    let cellHeight: CGFloat = 40
    
    let customTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredCustomFontWith(weight: .medium, size: 18)
        return label
    }()

    let customImageView: UIImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        
    }
}
