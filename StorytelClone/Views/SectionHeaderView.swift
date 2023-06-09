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
    static let topPadding: CGFloat = 31
    
    static func calculateEstimatedHeightFor(subCategory: SubCategory, superviewWidth: CGFloat) -> CGFloat {
        let headerContainer = SectionHeaderSubviewsContainer(addButtonAction: false)
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.widthAnchor.constraint(equalToConstant: superviewWidth).isActive = true
        headerContainer.configureFor(subCategory: subCategory)
        let height = headerContainer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }

    // MARK: - Instance properties
    private let containerWithSubviews = SectionHeaderSubviewsContainer(addButtonAction: true)

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
    func configureFor(subCategory: SubCategory, sectionNumber: Int? = nil, category: Category? = nil, forCategoryVcWithReferenceBook: Bool = false, withSeeAllButtonDidTapCallback callback: @escaping () -> () = {}) {
        containerWithSubviews.configureFor(subCategory: subCategory, sectionNumber: sectionNumber, category: category, forCategoryVcWithReferenceBook: forCategoryVcWithReferenceBook, withSeeAllButtonDidTapCallback: callback)
    }
    
}
