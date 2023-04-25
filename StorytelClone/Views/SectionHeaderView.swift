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
    
//    static func calculateEstimatedHeightFor(section: TableSection, superviewWidth: CGFloat) -> CGFloat {
//        let headerContainer = SectionHeaderSubviewsContainer(addButtonAction: false)
//        headerContainer.translatesAutoresizingMaskIntoConstraints = false
//        headerContainer.widthAnchor.constraint(equalToConstant: superviewWidth).isActive = true
//
//        headerContainer.configureFor(section: section)
//        let height = headerContainer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        return height
//    }
    
    static func calculateEstimatedHeightFor(tableSection: TableSection, sectionNumber: Int? = nil, category: Category? = nil, superviewWidth: CGFloat) -> CGFloat {
        let headerContainer = SectionHeaderSubviewsContainer(addButtonAction: false)
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.widthAnchor.constraint(equalToConstant: superviewWidth).isActive = true

//        headerContainer.configureFor(section: section)
        headerContainer.configureFor(tableSection: tableSection, sectionNumber: sectionNumber, category: category)
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
        contentView.backgroundColor = Utils.customBackgroundColor
        contentView.addSubview(containerWithSubviews)
        containerWithSubviews.translatesAutoresizingMaskIntoConstraints = false
        containerWithSubviews.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance methods
//    func configureFor(section: TableSection) {
//        containerWithSubviews.configureFor(section: section)
//    }
    
    
    
    
    
    
//    func configureFor(tableSection: TableSection, sectionNumber: Int, category: Category) {
//        containerWithSubviews.configureFor(tableSection: tableSection, sectionNumber: sectionNumber, category: category)
//    }
    
    // sectionNumber and category parameters are for use in CategoryViewController
    func configureFor(tableSection: TableSection, sectionNumber: Int? = nil, category: Category? = nil) {
        containerWithSubviews.configureFor(tableSection: tableSection, sectionNumber: sectionNumber, category: category)
    }
    
    
    
    
    
//    func changeTopAnchorConstant(toValue value: CGFloat = Constants.generalTopPaddingSectionHeader) {
//        containerWithSubviews.horzStackViewTopConstraint.constant = value
//    }
    
}
