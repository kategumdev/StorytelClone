//
//  SectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/2/23.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "SectionHeaderView"
    
    let containerWithSubviews = SectionHeaderSubviewsContainer()

    // MARK: - View life cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerWithSubviews)
        containerWithSubviews.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureFor(section: TableSection) {
        containerWithSubviews.tableSection = section
        containerWithSubviews.sectionTitleLabel.text = section.sectionTitle
        containerWithSubviews.sectionSubtitleLabel.text = section.sectionSubtitle
    }
    
}
