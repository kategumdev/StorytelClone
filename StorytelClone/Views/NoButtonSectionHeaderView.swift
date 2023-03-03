//
//  NoButtonSectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

class NoButtonSectionHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "NoButtonSectionHeaderView"
    
    static func calculateHeaderHeightFor(section: TableSection) -> CGFloat {
        let header = SectionHeaderSubviewsContainer(frame: .zero, withButton: false)
//        header.removeButtonAndReconfigure()
        header.sectionTitleLabel.text = section.sectionTitle
        header.sectionSubtitleLabel.text = section.sectionSubtitle
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    
    let containerWithSubviews: SectionHeaderSubviewsContainer = {
        let container = SectionHeaderSubviewsContainer(frame: .zero, withButton: false)
//        container.removeButtonAndReconfigure()
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
    
    func configureFor(section: TableSection) {
        containerWithSubviews.tableSection = section
        containerWithSubviews.sectionTitleLabel.text = section.sectionTitle
        containerWithSubviews.sectionSubtitleLabel.text = section.sectionSubtitle
    }
    
}
