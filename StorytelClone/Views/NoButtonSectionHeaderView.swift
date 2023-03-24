//
//  NoButtonSectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

class NoButtonSectionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Static properties and methods
    static let identifier = "NoButtonSectionHeaderView"
    
    static func calculateHeaderHeightFor(section: TableSection) -> CGFloat {
        let header = SectionHeaderSubviewsContainer(withButton: false)
        header.sectionTitleLabel.text = section.sectionTitle
        header.sectionSubtitleLabel.text = section.sectionSubtitle
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    
    // MARK: - Instance properties
    private let containerWithSubviews: SectionHeaderSubviewsContainer = {
        let container = SectionHeaderSubviewsContainer(withButton: false)
        return container
    }()

    // MARK: - View life cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerWithSubviews)
        containerWithSubviews.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    func configureFor(section: TableSection) {
        containerWithSubviews.tableSection = section
        containerWithSubviews.sectionTitleLabel.text = section.sectionTitle
        containerWithSubviews.sectionSubtitleLabel.text = section.sectionSubtitle
    }
    
}
