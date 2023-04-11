//
//  SectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/2/23.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Static properties and methods
    static let identifier = "SectionHeaderView"
    
    static func calculateHeaderHeightFor(section: TableSection) -> CGFloat {
        let header = SectionHeaderSubviewsContainer()
        header.sectionTitleLabel.text = section.sectionTitle
        header.sectionSubtitleLabel.text = section.sectionSubtitle
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    
    let containerWithSubviews = SectionHeaderSubviewsContainer()

    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerWithSubviews)
        containerWithSubviews.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    func configureFor(section: TableSection) {
        containerWithSubviews.tableSection = section
        containerWithSubviews.sectionTitleLabel.text = section.sectionTitle
        containerWithSubviews.sectionSubtitleLabel.text = section.sectionSubtitle
    }
    
}
