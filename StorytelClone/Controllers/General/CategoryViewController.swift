//
//  SeriesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

// Presented on button tap: Series button in HomeViewController and category buttons in AllCategoriesViewController
class CategoryViewController: BaseTableViewController {
    
    private lazy var similarBooksTopView = UIView()
    private let similarBooksTopViewY: CGFloat = 1000
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let headerView = bookTable.tableHeaderView as? TableHeaderView, let category = category else { return }
        
        if let book = category.bookForSimilar {
            // Replace tableHeaderView
            let newHeaderView = SimilarBooksTableHeaderView()
            newHeaderView.configureFor(book: book)
            bookTable.tableHeaderView = newHeaderView
            // These two lines avoid constraints' conflict of header and its label when view just loaded
            newHeaderView.translatesAutoresizingMaskIntoConstraints = false
            newHeaderView.fillSuperview()
            
            bookTable.backgroundColor = .clear
            
            similarBooksTopView.backgroundColor = Utils.powderGrayBackgroundColor
            
            bookTable.addSubview(similarBooksTopView)
            let zPosition = bookTable.layer.zPosition - 1
            similarBooksTopView.layer.zPosition = zPosition
            similarBooksTopView.frame = CGRect(origin: CGPoint(x: 0, y: -similarBooksTopViewY), size: CGSize(width: view.bounds.width, height: similarBooksTopViewY))

//            topBackgroundView.frame = CGRect(origin: CGPoint(x: 0, y: -similarBooksTopViewY), size: CGSize(width: view.bounds.width, height: similarBooksTopViewY))
            
            navigationController?.makeNavbarAppearance(transparent: true, withVisibleTitle: true)
        } else {
            headerView.configureWithDimView(andText: category.title)
            navigationController?.makeNavbarAppearance(transparent: true)
        }
        
//        headerView.configureWithDimView(andText: category.title)
//        navigationController?.makeNavbarAppearance(transparent: true)
        extendedLayoutIncludesOpaqueBars = true
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        guard let headerView = bookTable.tableHeaderView as? TableHeaderView, let category = category else { return }
//
//        if let book = category.bookForSimilar {
//            headerView.configureFor(tableSection: TableSection.librosSimilares, titleModel: book)
//            navigationController?.makeNavbarAppearance(transparent: true, withVisibleTitle: true)
//
//            bookTable.backgroundColor = .clear
////            headerView.backgroundColor = Utils.powderGrayBackgroundColor
//            similarBooksTopView.backgroundColor = Utils.powderGrayBackgroundColor
//
//            bookTable.addSubview(similarBooksTopView)
//            let zPosition = bookTable.layer.zPosition - 1
//            similarBooksTopView.layer.zPosition = zPosition
//            similarBooksTopView.frame = CGRect(origin: CGPoint(x: 0, y: -similarBooksTopViewY), size: CGSize(width: view.bounds.width, height: similarBooksTopViewY))
//        } else {
//            headerView.configureWithDimView(andText: category.title)
//            navigationController?.makeNavbarAppearance(transparent: true)
//        }
//
////        headerView.configureWithDimView(andText: category.title)
////        navigationController?.makeNavbarAppearance(transparent: true)
//        extendedLayoutIncludesOpaqueBars = true
//    }
    
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        guard category?.bookForSimilar != nil else { return }
        
        let contentOffsetY = scrollView.contentOffset.y
        if abs(contentOffsetY) > abs(tableViewInitialOffsetY) {
            similarBooksTopView.frame.size.height = similarBooksTopViewY + abs(contentOffsetY)
        } else {
            similarBooksTopView.frame.size.height = similarBooksTopViewY + abs(tableViewInitialOffsetY)
        }
    }
    
}
