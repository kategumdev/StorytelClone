//
//  CategoriesTableViewCellWithCollection.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class CategoriesTableViewCellWithCollection: UITableViewCell {
    
    var categoryButtons = [CategoryButton]()
    
    var callbackClosure: CategoryCollectionViewCell.ButtonCallbackClosure = {_ in}
    
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
    
    func configureWith(categoryButtons: [CategoryButton]) {
        self.categoryButtons = categoryButtons
    }

}

extension CategoriesTableViewCellWithCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryButtons.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell()}
        
        // Closure passed by AllCategoriesViewController. Pass it to CategoryCollectionViewCell
        cell.callbackClosure = callbackClosure
        
        cell.configure(withColor: categoryColors[indexPath.row], andCategoryOfButton: categoryButtons[indexPath.row])
        return cell
    }

}

extension CategoriesTableViewCellWithCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Utils.calculatedCvItemSizeCategory
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: Constants.cvPadding, bottom: Constants.gapBetweenSectionsOfCategoryTable, right: Constants.cvPadding)
    }
     
}
