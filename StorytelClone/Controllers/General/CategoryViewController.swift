//
//  SeriesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

// Presented on button tap: Series button in HomeViewController and category buttons in AllCategoriesViewController
class CategoryViewController: BaseTableViewController {
    
    private lazy var similarBooksTopView: UIView = {
        let view = UIView()
//        view.backgroundColor = .blue
        view.backgroundColor = UIColor(named: "backgroundBookOverview")
        return view
    }()
    
    private let similarBooksTopViewY: CGFloat = 1000
    
//    private lazy var similarBooksTopViewHeightConstraint: NSLayoutConstraint = similarBooksTopView.heightAnchor.constraint(equalToConstant: Utils.tabBarHeight)
//    private lazy var similarBooksTopViewBottomConstraint: NSLayoutConstraint = similarBooksTopView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
//    private lazy var similarBooksTopViewBottomConstraint: NSLayoutConstraint = similarBooksTopView.bottomAnchor.constraint(equalTo: bookTable.topAnchor, constant: Utils.tabBarHeight)
    private var similarBooksTopViewBottomConstraint: NSLayoutConstraint?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let headerView = bookTable.tableHeaderView as? TableHeaderView, let category = category else { return }
        
        if let book = category.bookForSimilar {
//            headerView.backgroundColor = .magenta
            headerView.configureFor(tableSection: TableSection.librosSimilares, titleModel: book)
            navigationController?.makeNavbarAppearance(transparent: true, withVisibleTitle: true)
            
            
//            headerView.backgroundColor = .blue
            headerView.backgroundColor = UIColor(named: "backgroundBookOverview")
            
//            view.backgroundColor = .blue
            bookTable.backgroundColor = .clear
            
//            view.addSubview(similarBooksTopView)
//            let zPosition = view.layer.zPosition - 1.0
//            let zPosition = bookTable.layer.zPosition - 1
//            similarBooksTopView.layer.zPosition = zPosition
            
            bookTable.addSubview(similarBooksTopView)
            let zPosition = bookTable.layer.zPosition - 1
            similarBooksTopView.layer.zPosition = zPosition
//            similarBooksTopView.frame = CGRect(origin: CGPoint(x: 0, y: -Utils.tabBarHeight), size: CGSize(width: view.bounds.width, height: 250))
            similarBooksTopView.frame = CGRect(origin: CGPoint(x: 0, y: -similarBooksTopViewY), size: CGSize(width: view.bounds.width, height: similarBooksTopViewY))

//            similarBooksTopView.frame = CGRect(origin: CGPoint(x: 0, y: -92), size: CGSize(width: view.bounds.width, height: bookTable.contentSize.height))

//            similarBooksTopView.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 30))
//            similarBooksTopView.clipsToBounds = false
            
            
//            view.addSubview(similarBooksTopView)
//            similarBooksTopView.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 50))
//            similarBooksTopView.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                similarBooksTopView.topAnchor.constraint(equalTo: view.topAnchor),
//                similarBooksTopView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                similarBooksTopView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            ])
//
//            similarBooksTopViewBottomConstraint = similarBooksTopView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
//            similarBooksTopViewBottomConstraint?.isActive = true
////            similarBooksTopViewHeightConstraint.isActive = true
            
//            similarBooksTopView.translatesAutoresizingMaskIntoConstraints = false
//            let contentG = bookTable.frameLayoutGuide
//            NSLayoutConstraint.activate([
//                similarBooksTopView.topAnchor.constraint(equalTo: bookTable.frameLayoutGuide.topAnchor),
////                similarBooksTopView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//                similarBooksTopView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
//                similarBooksTopView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
//                similarBooksTopView.bottomAnchor.constraint(equalTo: contentG.topAnchor, constant: 30)
//            ])
            
//            NSLayoutConstraint.activate([
////                similarBooksTopView.topAnchor.constraint(equalTo: bookTable.topAnchor),
//                similarBooksTopView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//                similarBooksTopView.leadingAnchor.constraint(equalTo: bookTable.leadingAnchor),
//                similarBooksTopView.trailingAnchor.constraint(equalTo: bookTable.trailingAnchor),
//                similarBooksTopView.bottomAnchor.constraint(equalTo: bookTable.topAnchor, constant: 30)
//            ])
            
            
        } else {
            headerView.configureWithDimView(andText: category.title)
            navigationController?.makeNavbarAppearance(transparent: true)
        }
        
//        headerView.configureWithDimView(andText: category.title)
//        navigationController?.makeNavbarAppearance(transparent: true)
        extendedLayoutIncludesOpaqueBars = true

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = view.bounds
        frame.size.height -= Utils.tabBarHeight
        bookTable.frame = frame
        
//        print("contentSize: \(bookTable.contentSize.height)")
//        similarBooksTopView.frame = CGRect(origin: CGPoint(x: 0, y: -92), size: CGSize(width: view.bounds.width, height: bookTable.contentSize.height))
//        similarBooksTopView.frame.size.height = bookTable.contentSize.height
        
//        similarBooksTopView.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: abs(tableViewInitialOffsetY)))
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
        
        let contentOffsetY = scrollView.contentOffset.y
//        print("contentOffsetY: \(contentOffsetY), tableViewInitialOffsetY: \(tableViewInitialOffsetY)")
        
//        let newConstant = contentOffsetY > tableViewInitialOffsetY ? Utils.tabBarHeight + contentOffsetY :
        
//        if abs(contentOffsetY) > abs(tableViewInitialOffsetY) {
//            let newConstant = - (abs(tableViewInitialOffsetY) +
//        }
        
//        if contentOffsetY < tableViewInitialOffsetY {
//            similarBooksTopViewBottomConstraint.constant += contentOffsetY
//        }
        
//        if contentOffsetY < tableViewInitialOffsetY {
//            similarBooksTopViewBottomConstraint.constant = abs(contentOffsetY)
//        } else {
//            similarBooksTopViewBottomConstraint.constant = abs(tableViewInitialOffsetY)
//        }
//        similarBooksTopViewBottomConstraint.constant = abs(contentOffsetY)
        
        
//        if abs(contentOffsetY) > abs(tableViewInitialOffsetY) {
//            similarBooksTopViewHeightConstraint.constant = abs(contentOffsetY)
//        } else {
//            similarBooksTopViewHeightConstraint.constant = abs(tableViewInitialOffsetY)
//        }
        
        
        
        
        
        
        

        if abs(contentOffsetY) > abs(tableViewInitialOffsetY) {
//            similarBooksTopView.frame.size.height = abs(contentOffsetY)
            similarBooksTopView.frame.size.height = similarBooksTopViewY + abs(contentOffsetY)

//            DispatchQueue.main.async { [weak self] in
//                self?.similarBooksTopView.frame.size.height = abs(contentOffsetY)
//            }

//            similarBooksTopView.frame.size.height = 200

        } else {
//            similarBooksTopView.frame.size.height = abs(tableViewInitialOffsetY)
            similarBooksTopView.frame.size.height = similarBooksTopViewY + abs(tableViewInitialOffsetY)
        }
        
        
        
        
        
        
//        let newConstant =
//        similarBooksTopViewBottomConstraint.constant = abs(tableViewInitialOffsetY)
        
//        if contentOffsetY < tableViewInitialOffsetY {
//            print("setting")
////            let newConstant = abs(tableViewInitialOffsetY) - abs(contentOffsetY)
////            similarBooksTopViewBottomConstraint.constant = newConstant
//            similarBooksTopViewHeightConstraint.constant = abs(contentOffsetY)
//            view.layoutIfNeeded()
////            similarBooksTopViewBottomConstraint.constant = abs(contentOffsetY)
//        } else {
////            similarBooksTopViewBottomConstraint.constant = 0
//            similarBooksTopViewHeightConstraint.constant = abs(tableViewInitialOffsetY)
//            view.layoutIfNeeded()
//        }
        
        
//        similarBooksTopViewBottomConstraint.constant =
    }
    
}
