//
//  AllCategoriesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class AllCategoriesViewController: BaseViewController {
    
    private let categoriesForButtons: [Category]
    
    // MARK: - Initializers
    init(categoryModel: Category, categoriesForButtons: [Category]) {
        self.categoriesForButtons = categoriesForButtons
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
        navigationController?.makeAppearance(transparent: true)
        title = category.title
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AllCategoriesViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCellWithCollection.identifier, for: indexPath) as? CategoriesTableViewCellWithCollection else { return UITableViewCell() }
            cell.configureWith(categoriesForButtons: self.categoriesForButtons, andCallback: dimmedAnimationButtonDidTapCallback)
//        cell.configureWith(categoryButtons: self.categoryButtons, andCallback: dimmedAnimationButtonDidTapCallback)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let numberOfButtons = categoryButtons.count
        let numberOfButtons = categoriesForButtons.count
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
