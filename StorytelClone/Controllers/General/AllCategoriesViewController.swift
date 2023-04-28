//
//  AllCategoriesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class AllCategoriesViewController: BaseTableViewController {
    
    private let categoryButtons: [ButtonCategory]
    
    // MARK: - Initializers
    init(categoryModel: Category, categoryButtons: [ButtonCategory]) {
        self.categoryButtons = categoryButtons
        super.init(categoryModel: categoryModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bookTable.register(CategoriesTableViewCellWithCollection.self, forCellReuseIdentifier: CategoriesTableViewCellWithCollection.identifier)
        bookTable.estimatedSectionHeaderHeight = 0
        
        
        guard let headerView = bookTable.tableHeaderView as? TableHeaderView, let category = category else { return }
        
        headerView.configureWithDimView(andText: category.title)
        navigationController?.makeNavbarAppearance(transparent: true)
        title = category.title

    }

    //MARK: - Helper methods
//    private func getModelFor(buttonCategory: ButtonCategory) -> Category {
//        return ButtonCategory.createModelFor(categoryButton: buttonCategory)
//    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AllCategoriesViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCellWithCollection.identifier, for: indexPath) as? CategoriesTableViewCellWithCollection else { return UITableViewCell() }
        
        // Respond to button tap in CategoryCollectionViewCell
        let callback: DimmedAnimationButtonDidTapCallback = { [weak self] controller in
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        cell.configureWith(categoryButtons: self.categoryButtons, andCallback: callback)
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCellWithCollection.identifier, for: indexPath) as? CategoriesTableViewCellWithCollection else { return UITableViewCell() }
//
//        // Respond to button tap in CategoryCollectionViewCell
//        cell.dimmedAnimationButtonDidTapCallback = { [weak self] buttonCategory in
//            guard let self = self, let buttonCategory = buttonCategory as? ButtonCategory else { return }
//
////            let categoryModel = self.getModelFor(buttonCategory: buttonCategory)
//            let categoryModel = ButtonCategory.createModelFor(categoryButton: buttonCategory)
//            let controller = CategoryViewController(categoryModel: categoryModel)
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//        cell.categoryButtons = self.categoryButtons
//
//        return cell
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCellWithCollection.identifier, for: indexPath) as? CategoriesTableViewCellWithCollection else { return UITableViewCell() }
//
//        // Respond to button tap in CategoryCollectionViewCell
//        cell.dimmedAnimationButtonDidTapCallback = { [weak self] buttonCategory in
//            guard let self = self, let buttonCategory = buttonCategory as? ButtonCategory else { return }
//
////            let categoryModel = self.getModelFor(buttonCategory: buttonCategory)
//            let categoryModel = ButtonCategory.createModelFor(categoryButton: buttonCategory)
//            let controller = CategoryViewController(categoryModel: categoryModel)
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//        cell.categoryButtons = self.categoryButtons
//
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let numberOfButtons = categoryButtons.count
        let numberOfRowsInCell: CGFloat = ceil(CGFloat(numberOfButtons) / 2.0)

        let height = CategoriesTableViewCellWithCollection.calculateCellHeightFor(numberOfRows: numberOfRowsInCell)
        
        return height
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
}
