//
//  AllCategoriesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class AllCategoriesViewController: BaseTableViewController {
    
    private let categoryButtons: [CategoryButton]
    
    init(categoryModel: Category, categoryButtons: [CategoryButton]) {
        self.categoryButtons = categoryButtons
        super.init(categoryModel: categoryModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bookTable.register(CategoriesTableViewCellWithCollection.self, forCellReuseIdentifier: CategoriesTableViewCellWithCollection.identifier)
        
        bookTable.estimatedSectionHeaderHeight = 0
        
        guard let headerView = bookTable.tableHeaderView as? FeedTableHeaderView else { return }
        headerView.headerLabel.text = category.title
        headerView.topAnchorConstraint.constant = FeedTableHeaderView.labelTopAnchorForCategory
        
        title = category.title
        navigationItem.backButtonTitle = ""
    }
    
    //MARK: - Helper methods
    private func getModelFor(categoryButton: CategoryButton) -> Category {
        return CategoryButton.createModelFor(categoryButton: categoryButton)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AllCategoriesViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCellWithCollection.identifier, for: indexPath) as? CategoriesTableViewCellWithCollection else { return UITableViewCell() }
        
        // Respond to button tap in CategoryCollectionViewCell
        cell.callbackClosure = { [weak self] buttonCategory in
            guard let self = self else { return }
            let category = self.getModelFor(categoryButton: buttonCategory)
            let controller = CategoryViewController(categoryModel: category)
            self.navigationController?.pushViewController(controller, animated: true)
        }
 
        cell.categoryButtons = self.categoryButtons
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (Utils.calculatedCvItemSizeCategory.height * 10) + (Constants.cvPadding * 9) + Constants.gapBetweenSectionsOfCategoryTable
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 41
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
