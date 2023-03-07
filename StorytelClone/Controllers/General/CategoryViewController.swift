//
//  SeriesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

// Presented on button tap: Series button in HomeViewController and category buttons in AllCategoriesViewController
class CategoryViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let headerView = bookTable.tableHeaderView as? FeedTableHeaderView else { return }
        headerView.headerLabel.text = category.title
        headerView.topAnchorConstraint.constant = FeedTableHeaderView.labelTopAnchorForCategory
        
        navigationItem.backButtonTitle = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentOffsetY = bookTable.contentOffset.y
        adjustNavBarAppearanceFor(currentOffsetY: currentOffsetY)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }
        
        // Dependency injection
        cell.books = category.tableSections[indexPath.row].books
        
        // Respond to button tap in BookCollectionViewCell of TableViewCellWithCollection
        cell.callbackClosure = { [weak self] book in
            guard let self = self else { return }
            let controller = BookViewController(book: book as? Book)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        return cell
    }
    
    override func configureNavBar() {
        super.configureNavBar()
        var text = category.title
        text = text.replacingOccurrences(of: "\n", with: " ")
        title = text
    }
    
}