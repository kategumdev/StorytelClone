//
//  AllCategoriesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class AllCategoriesViewController: BaseTableViewController {
    
    private let categoryButtons: [ButtonCategory]
    
    init(categoryModel: Category, categoryButtons: [ButtonCategory]) {
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
        headerView.topAnchorConstraint.constant = FeedTableHeaderView.labelTopAnchorForCategoryOrSectionTitle
        
        title = category.title
        navigationItem.backButtonTitle = ""
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        print("viewDidDisappear")
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentOffsetY = bookTable.contentOffset.y
        adjustNavBarAppearanceFor(currentOffsetY: currentOffsetY)
    }
    
    //MARK: - Helper methods
    private func getModelFor(buttonCategory: ButtonCategory) -> Category {
        return ButtonCategory.createModelFor(categoryButton: buttonCategory)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AllCategoriesViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCellWithCollection.identifier, for: indexPath) as? CategoriesTableViewCellWithCollection else { return UITableViewCell() }
        
        // Respond to button tap in CategoryCollectionViewCell
        cell.callbackClosure = { [weak self] buttonCategory in
            guard let self = self, let category = buttonCategory as? ButtonCategory else { return }
            
            let categoryModel = self.getModelFor(buttonCategory: category)
            let controller = CategoryViewController(categoryModel: categoryModel)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        cell.categoryButtons = self.categoryButtons
        
        return cell
    }
    
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

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.generalTopPaddingSectionHeader
    }
}
