//
//  AllCategoriesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class AllCategoriesViewController: BaseTableViewController {
    
    private let categories: [Category]
    
    init(categories: [Category]) {
        self.categories = categories
        super.init(model: Category.todasLasCategorias) // Change this
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookTable.register(CategoriesTableViewCellWithCollection.self, forCellReuseIdentifier: CategoriesTableViewCellWithCollection.identifier)
        
        bookTable.estimatedSectionHeaderHeight = 0
        
        guard let headerView = bookTable.tableHeaderView as? FeedTableHeaderView else { return }
        headerView.headerLabel.text = vcCategory.title
        headerView.topAnchorConstraint.constant = FeedTableHeaderView.labelTopAnchorForCategory
        
        title = vcCategory.title
        navigationItem.backButtonTitle = ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCellWithCollection.identifier, for: indexPath) as? CategoriesTableViewCellWithCollection else { return UITableViewCell() }
        cell.delegate = self
        cell.categories = self.categories
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


extension AllCategoriesViewController: CategoriesTableViewCellWithCollectionDelegate {
    func cellInCategoriesTableViewCellDidTapButton(_ cell: CategoriesTableViewCellWithCollection, withCategory category: Category) {
        let controller = SeriesViewController(model: category)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

