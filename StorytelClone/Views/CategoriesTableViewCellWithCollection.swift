//
//  CategoriesTableViewCellWithCollection.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

protocol CategoriesTableViewCellWithCollectionDelegate: AnyObject {
    func cellInCategoriesTableViewCellDidTapButton(
        _ cell: CategoriesTableViewCellWithCollection, withCategory category: Category)
}

class CategoriesTableViewCellWithCollection: UITableViewCell {
    
//    private let categoryTitles = ["Novela", "Zona Podcast", "Novela negra", "Romántica", "Thriller y Horror", "Fantasía y\nCiencia ficción", "Crecimiento\nPersonal y Lifestyle", "Infantil",
//    "Clásicos", "Juvenil y\nYoung Adult", "Erótica", "No ficción", "Economía y negocios", "Relatos cortos", "Historia", "Espiritualidad\ny Religión", "Biografías", "Poesía y teatro", "Aprender idiomas", "In English"]
    
    var categories = [Category]()

    weak var delegate: CategoriesTableViewCellWithCollectionDelegate?
    
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
    
    func configureWith(categories: [Category]) {
        self.categories = categories
    }

}

extension CategoriesTableViewCellWithCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell()}
        cell.delegate = self
        cell.configure(withColor: categoryColors[indexPath.row], andCategory: categories[indexPath.row])
        
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

extension CategoriesTableViewCellWithCollection: CategoryCollectionViewCellDelegate {
    func categoryCollectionViewCellDidTapButton(_ cell: CategoryCollectionViewCell, withCategory category: Category) {
        delegate?.cellInCategoriesTableViewCellDidTapButton(self, withCategory: category)
    }
}
