//
//  SectionHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 18/2/23.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "SectionHeaderView"
    
    static func calculateHeaderHeightFor(section: TableSection) -> CGFloat {
        let header = SectionHeaderSubviewsContainer(frame: .zero)
        header.sectionTitleLabel.text = section.sectionTitle
        header.sectionSubtitleLabel.text = section.sectionSubtitle
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    
    let containerWithSubviews = SectionHeaderSubviewsContainer(frame: .zero)

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
