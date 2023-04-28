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
    
    static func calculateEstimatedHeightFor(tableSection: TableSection, superviewWidth: CGFloat, sectionNumber: Int? = nil, category: Category? = nil) -> CGFloat {
        let headerContainer = SectionHeaderSubviewsContainer(addButtonAction: false)
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.widthAnchor.constraint(equalToConstant: superviewWidth).isActive = true
        headerContainer.configureFor(tableSection: tableSection, sectionNumber: sectionNumber, category: category, withSeeAllButtonDidTapCallback: {})
        let height = headerContainer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }

    // MARK: - Instance properties
    private let containerWithSubviews = SectionHeaderSubviewsContainer(addButtonAction: true)

    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Utils.customBackgroundColor
        contentView.addSubview(containerWithSubviews)
        containerWithSubviews.translatesAutoresizingMaskIntoConstraints = false
        containerWithSubviews.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance methods
    func configureFor(tableSection: TableSection, sectionNumber: Int? = nil, category: Category? = nil, withSeeAllButtonDidTapCallback callback: @escaping () -> ()) {
        containerWithSubviews.configureFor(tableSection: tableSection, sectionNumber: sectionNumber, category: category, withSeeAllButtonDidTapCallback: callback)
    }
    
}
