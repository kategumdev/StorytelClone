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
    
    static func calculateCellHeightFor(numberOfRows: CGFloat) -> CGFloat {
        let paddings = (Constants.commonHorzPadding * (numberOfRows - 1)) + gapBetweenHeaderAndCell
        let height = (calculatedCvItemSizeCategory.height * numberOfRows) + paddings
        return height
    }
    
    static let calculatedCvItemSizeCategory: CGSize = {
        let height = cvItemHeight
        
        let contentViewWidth = UIScreen.main.bounds.size.width
        let width = round(contentViewWidth - (Constants.commonHorzPadding * 3)) / 2
        
        let size = CGSize(width: width, height: height)
        return size
    }()
    
    // MARK: - Instance properties
    private var categoriesForButtons = [Category]()
    private var dimmedAnimationButtonDidTapCallback: DimmedAnimationBtnDidTapCallback = {_ in}
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.commonHorzPadding
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.customBackgroundColor
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // MARK: - Instance method
    func configureWith(
        categoriesForButtons: [Category],
        callback: @escaping DimmedAnimationBtnDidTapCallback
    ) {
        self.categoriesForButtons = categoriesForButtons
        self.dimmedAnimationButtonDidTapCallback = callback
    }
    
    private func setupUI() {
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CategoriesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesForButtons.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.identifier,
            for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        
        // Closure received from AllCategoriesViewController. Passing it here to CategoryCollectionViewCell
        cell.configureFor(
            category: categoriesForButtons[indexPath.row],
            withCallback: dimmedAnimationButtonDidTapCallback)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CategoriesTableViewCell.calculatedCvItemSizeCategory
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        /* Top inset is needed for cell in last table section of SearchViewController. Calculating
         heightForRow for CategoriesTableViewCell add gapBetweenHeaderAndCell */
        UIEdgeInsets(
            top: CategoriesTableViewCell.gapBetweenHeaderAndCell,
            left: Constants.commonHorzPadding,
            bottom: 0,
            right: Constants.commonHorzPadding)
    }
}
