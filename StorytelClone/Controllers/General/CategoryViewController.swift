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
        if let headerView = bookTable.tableHeaderView as? TableHeaderView {
            headerView.configureWithDimView(andText: category.title)
        }
        
//        navigationController?.navigationBar.standardAppearance = UINavigationController.transparentNavBarAppearance
        navigationController?.makeNavbarAppearance(transparent: true)
//        navigationItem.backButtonTitle = ""
        extendedLayoutIncludesOpaqueBars = true
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        adjustNavBarAppearanceTo(currentOffsetY: bookTable.contentOffset.y)
//    }
    
    // MARK: - Superclass overrides
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }
        
        // Dependency injection
        cell.books = category.tableSections[indexPath.row].books
        
        // Respond to button tap in BookCollectionViewCell of TableViewCellWithCollection
        cell.callbackClosure = { [weak self] book in
            guard let self = self else { return }
            let book = book as! Book
            let controller = BookViewController(book: book)
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
