//
//  CategoriesTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

/// Includes collection view with buttons for every category
class CategoriesTableViewCell: UITableViewCell {
    // MARK: - Static properties and methods
    static let identifier = "CategoriesTableViewCell"
    static let gapBetweenHeaderAndCell: CGFloat = 9
    static let cvItemHeight: CGFloat = 120
    
    static let calculatedCvItemSizeCategory: CGSize = {
        let height = cvItemHeight
        
        let contentViewWidth = UIScreen.main.bounds.size.width
        let width = round(contentViewWidth - (Constants.commonHorzPadding * 3)) / 2

        let size = CGSize(width: width, height: height)
        return size
    }()
    
    static func calculateCellHeightFor(numberOfRows: CGFloat) -> CGFloat {
        let paddings = (Constants.commonHorzPadding * (numberOfRows - 1)) + gapBetweenHeaderAndCell
        let height = (calculatedCvItemSizeCategory.height * numberOfRows) + paddings
        return height
    }
    
    // MARK: - Instance properties
    private var categoriesForButtons = [Category]()
    private var dimmedAnimationButtonDidTapCallback: DimmedAnimationButtonDidTapCallback = {_ in}
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.commonHorzPadding
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.customBackgroundColor
        collectionView.isScrollEnabled = false

        return collectionView
    }()
 
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // MARK: - Instance methods
    func configureWith(categoriesForButtons: [Category], andCallback callback: @escaping DimmedAnimationButtonDidTapCallback) {
        self.categoriesForButtons = categoriesForButtons
        self.dimmedAnimationButtonDidTapCallback = callback
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CategoriesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesForButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell()}
        
        // Closure passed by AllCategoriesViewController. Pass it to CategoryCollectionViewCell
        cell.configureFor(category: categoriesForButtons[indexPath.row], withCallback: dimmedAnimationButtonDidTapCallback)
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CategoriesTableViewCell.calculatedCvItemSizeCategory
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // This top inset is for cell in last section of SearchViewController
        // Add gapBetweenHeaderAndCell when calculating heightForRow for all CategoriesTableViewCellWithCollection cells
        UIEdgeInsets(top: CategoriesTableViewCell.gapBetweenHeaderAndCell, left: Constants.commonHorzPadding, bottom: 0, right: Constants.commonHorzPadding)
    }
     
}