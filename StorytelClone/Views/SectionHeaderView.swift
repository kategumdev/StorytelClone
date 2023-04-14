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
    
    static func calculateEstimatedHeightFor(section: TableSection, superviewWidth: CGFloat) -> CGFloat {
        let headerContainer = SectionHeaderSubviewsContainer(addButtonAction: false)
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.widthAnchor.constraint(equalToConstant: superviewWidth).isActive = true

        headerContainer.configureFor(section: section)
        let height = headerContainer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }

    // MARK: - Instance properties
    private let containerWithSubviews = SectionHeaderSubviewsContainer(addButtonAction: true)
    
    var seeAllButtonDidTapCallback: SeeAllButtonDidTapCallback = {} {
        didSet {
            containerWithSubviews.callback = seeAllButtonDidTapCallback
        }
    }
    
    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerWithSubviews)
        containerWithSubviews.translatesAutoresizingMaskIntoConstraints = false
        containerWithSubviews.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance methods
    func configureFor(section: TableSection) {
        containerWithSubviews.configureFor(section: section)
    }
    
}
