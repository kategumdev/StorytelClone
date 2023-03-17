//
//  CategoriesTableViewCellWithCollection.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class CategoriesTableViewCellWithCollection: UITableViewCell {
    
    static let gapBetweenHeaderAndCell: CGFloat = 9
    
    static let calculatedCvItemSizeCategory: CGSize = {
        let height = Constants.categoryCvItemHeight
        
        let contentViewWidth = UIScreen.main.bounds.size.width
        let width = round(contentViewWidth - (Constants.cvPadding * 3)) / 2

        let size = CGSize(width: width, height: height)
        return size
    }()
    
    static func calculateCellHeightFor(numberOfRows: CGFloat) -> CGFloat {
        let paddings = (Constants.cvPadding * (numberOfRows - 1)) + gapBetweenHeaderAndCell
        let height = (calculatedCvItemSizeCategory.height * numberOfRows) + paddings
        return height
    }
    
    var categoryButtons = [ButtonCategory]()
    
    var callbackClosure: ButtonCallback = {_ in}
    
    private let categoryColors = [Utils.pinkCategoryColor, Utils.orangeCategoryColor, Utils.orangeCategoryColor, Utils.coralCategoryColor, Utils.darkBlueCategoryColor, Utils.lightBlueCategoryColor, Utils.lightBlueCategoryColor, Utils.yellowCategoryColor, Utils.peachCategoryColor, Utils.lightBlueCategoryColor, Utils.pinkCategoryColor, Utils.greenCategoryColor, Utils.greenCategoryColor, Utils.darkBlueCategoryColor, Utils.orangeCategoryColor, Utils.yellowCategoryColor, Utils.greenCategoryColor, Utils.lightBlueCategoryColor, Utils.greenCategoryColor, Utils.darkBlueCategoryColor]
    
    static let identifier = "CategoriesTableViewCellWithCollection"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.cvPadding
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = Utils.customBackgroundColor
        collectionView.isScrollEnabled = false

        return collectionView
    }()
 
    // MARK: - View life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    
    // MARK: - Helper methods
    func configureWith(categoryButtons: [ButtonCategory]) {
        self.categoryButtons = categoryButtons
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CategoriesTableViewCellWithCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell()}
        
        // Closure passed by AllCategoriesViewController. Pass it to CategoryCollectionViewCell
        cell.configure(withColor: categoryColors[indexPath.row], categoryOfButton: categoryButtons[indexPath.row], callback: callbackClosure)
        
        return cell
    }

}

extension CategoriesTableViewCellWithCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CategoriesTableViewCellWithCollection.calculatedCvItemSizeCategory
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // This top inset is for cell in last section of SearchViewController
        // Add gapBetweenHeaderAndCell when calculating heightForRow for all CategoriesTableViewCellWithCollection cells
        UIEdgeInsets(top: CategoriesTableViewCellWithCollection.gapBetweenHeaderAndCell, left: Constants.cvPadding, bottom: 0, right: Constants.cvPadding)
    }
     
}
