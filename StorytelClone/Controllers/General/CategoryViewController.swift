//
//  SeriesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

// Presented on button tap: Series button in HomeViewController and category buttons in AllCategoriesViewController
class CategoryViewController: BaseTableViewController {

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let headerView = bookTable.tableHeaderView as? TableHeaderView, let category = category else { return }
        
        if let book = category.bookForSimilar {
//            headerView.backgroundColor = .magenta
            headerView.configureFor(tableSection: TableSection.librosSimilares, titleModel: book)
            navigationController?.makeNavbarAppearance(transparent: true, withVisibleTitle: true)
        } else {
            headerView.configureWithDimView(andText: category.title)
            navigationController?.makeNavbarAppearance(transparent: true)
        }
        
        
        
        
//        if category.forBooksSimilarTo {
////            headerView.backgroundColor = .magenta
//            headerView.configureFor(tableSection: TableSection.librosSimilares, titleModel: tableSection?.titleModel)
//            navigationController?.makeNavbarAppearance(transparent: true, withVisibleTitle: true)
//        } else {
//            headerView.configureWithDimView(andText: category.title)
//            navigationController?.makeNavbarAppearance(transparent: true)
//        }
        
        
        
//        headerView.configureWithDimView(andText: category.title)
//        navigationController?.makeNavbarAppearance(transparent: true)
        extendedLayoutIncludesOpaqueBars = true

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = view.bounds
        frame.size.height -= Utils.tabBarHeight
        bookTable.frame = frame
    }

    // MARK: - Superclass overrides
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }
        
        if let category = category {
            cell.books = category.tableSections[indexPath.row].books
        }
//        cell.books = category.tableSections[indexPath.row].books
        
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
        guard let category = category else { return }
        var text = category.title
        text = text.replacingOccurrences(of: "\n", with: " ")
        title = text
    }
    
    
//    override func adjustNavBarAppearanceTo(currentOffsetY: CGFloat) {
//        guard let tableHeaderHeight = bookTable.tableHeaderView?.bounds.size.height else { return }
//
//        changeHeaderDimViewAlphaWith(currentOffsetY: currentOffsetY)
//
//        var offsetYToCompareTo = category?.bookForSimilar != nil ? tableViewInitialOffsetY : tableViewInitialOffsetY + tableHeaderHeight + 10
//
////        let offsetYToCompareTo = tableViewInitialOffsetY + tableHeaderHeight + 10
//        navigationController?.adjustAppearanceTo(currentOffsetY: currentOffsetY, offsetYToCompareTo: offsetYToCompareTo)
//    }
    
}
