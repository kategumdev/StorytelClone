//
//  AllCategoriesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class AllCategoriesViewController: BaseViewController {
    private let categoriesForButtons: [Category]
    
    init(category: Category, categoriesForButtons: [Category]) {
        self.categoriesForButtons = categoriesForButtons
        super.init(category: category)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
    }
    
    private func configureSelf() {
        bookTable.register(
            CategoriesTableViewCell.self,
            forCellReuseIdentifier: CategoriesTableViewCell.identifier)
        
        bookTable.estimatedSectionHeaderHeight = 0
        
        guard let headerView = bookTable.tableHeaderView as? TableHeaderView,
              let category = category
        else { return }
        
        headerView.configureWithDimView(andText: category.title)
        navigationController?.makeAppearance(transparent: true)
        title = category.title
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AllCategoriesViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoriesTableViewCell.identifier,
            for: indexPath
        ) as? CategoriesTableViewCell else { return UITableViewCell() }
        
        cell.configureWith(
            categoriesForButtons: self.categoriesForButtons,
            callback: dimmedAnimationBtnCallback)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let numberOfButtons = categoriesForButtons.count
        let numberOfRowsInCell: CGFloat = ceil(CGFloat(numberOfButtons) / 2.0)
        let height = CategoriesTableViewCell.calculateCellHeightFor(numberOfRows: numberOfRowsInCell)
        return height
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
}
