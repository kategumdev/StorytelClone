//
//  AllTitlesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 31/3/23.
//

import UIKit

class AllTitlesViewController: BaseTableViewController {

    let tableSection: TableSection
    let titleModel: Title?
    
    private let books = Book.books + [Book.book20, Book.book21, Book.book22, Book.book23] + [Book.senorDeLosAnillos1, Book.senorDeLosAnillos2]
//    private let books = [Book.book1, Book.book1, Book.book1, Book.book1,
//                         Book.book1, Book.book1, Book.book1, Book.book1,
//                         Book.book1, Book.book1, Book.book1, Book.book1,
//                         Book.book1, Book.book1, Book.book1, Book.book1]
    
    init(tableSection: TableSection, categoryOfParentVC: Category, titleModel: Title?) {
        self.tableSection = tableSection
        self.titleModel = titleModel
        super.init(categoryModel: categoryOfParentVC, tableViewStyle: .plain)
        #warning("This category is not needed in this vc, only needed for BaseTableViewController initializer")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBookTable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = view.bounds
        frame.size.height = view.bounds.height - Utils.tabBarHeight
        bookTable.frame = frame
    }
    
    private func configureBookTable() {
        bookTable.separatorColor = UIColor.tertiaryLabel
        bookTable.separatorInset = UIEdgeInsets(top: 0, left: Constants.cvPadding, bottom: 0, right: Constants.cvPadding)
        
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bookTable.contentInset = inset
        
        bookTable.register(AllTitlesSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: AllTitlesSectionHeaderView.identifier)
        bookTable.register(AllTitlesTableViewCell.self, forCellReuseIdentifier: AllTitlesTableViewCell.identifier)
                
        if titleModel?.titleKind == .author || titleModel?.titleKind == .narrator {
            let headerView = StorytellerTableHeaderView()
            headerView.configureFor(storyteller: titleModel!)
            bookTable.tableHeaderView = headerView
            
            // These two lines avoid constraints' conflict of header and its label when view just loaded
            headerView.translatesAutoresizingMaskIntoConstraints = false
            headerView.fillSuperview()
//            layoutHeaderView()
            return
        }
        
        guard let headerView = bookTable.tableHeaderView as? TableHeaderView else { return }
        
        if let sectionDescription = tableSection.sectionDescription {
            headerView.configureWith(title: tableSection.sectionTitle, sectionDescription: sectionDescription)
        } else if tableSection.forSimilarBooks, let book = titleModel as? Book {
            headerView.configureWith(title: tableSection.sectionTitle, bookTitleForSimilar: book.title)
        } else if let series = titleModel as? Series {
            headerView.configureWith(series: series)
        } else if let tag = titleModel as? Tag {
            headerView.configureWith(title: tag.tagTitle)
        } else {
            headerView.configureWith(title: tableSection.sectionTitle)
        }
        
        headerView.stackTopAnchorConstraint.constant = headerView.stackTopAnchorForCategoryOrSectionTitle
    }
    
    // MARK: - Superclass overrides
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableSection.books.count
        return books.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllTitlesTableViewCell.identifier, for: indexPath) as? AllTitlesTableViewCell else { return UITableViewCell() }
        
        cell.configureFor(book: books[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let book = books[indexPath.row]
        return AllTitlesTableViewCell.getEstimatedHeightForRowWith(width: view.bounds.width, andBook: book)
//        return AllTitlesTableViewCell.getEstimatedHeightForRow(withBook: book)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: AllTitlesSectionHeaderView.identifier) as? AllTitlesSectionHeaderView else {
            return UIView()
        }
        sectionHeader.configureWith(title: "All titles")
        
        if tableSection.canBeFiltered && tableSection.canBeShared {
            sectionHeader.showShareAndFilterButtons()
        } else if tableSection.canBeFiltered {
            sectionHeader.showOnlyFilterButton()
        } else {
            sectionHeader.showOnlyShareButton()
        }
        
        return sectionHeader
    }
    
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let calculatedHeight = AllTitlesSectionHeaderView.calculateEstimatedHeaderHeight()
//
//        return calculatedHeight
////        return 40
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Hide separator line under the last cell
        if indexPath.row == books.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width / 2, bottom: 0, right: cell.bounds.width / 2)
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let calculatedHeight = AllTitlesSectionHeaderView.calculateEstimatedHeaderHeight()
        return calculatedHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func configureNavBar() {
        super.configureNavBar()
        
        var text: String
        if let author = titleModel as? Author {
            text = author.name
        } else if let narrator = titleModel as? Narrator {
            text = narrator.name
        } else if let series = titleModel as? Series {
            text = series.title
        } else if let tag = titleModel as? Tag {
            text = tag.tagTitle
        } else {
            text = tableSection.sectionTitle
        }
        
//        var text = tableSection.sectionTitle
        text = text.replacingOccurrences(of: "\n", with: " ")
        title = text
        
        extendedLayoutIncludesOpaqueBars = true
        navigationItem.backButtonTitle = ""
    }
    
    override func adjustNavBarAppearanceFor(currentOffsetY: CGFloat) {
        if currentOffsetY > tableViewInitialOffsetY && navigationController?.navigationBar.standardAppearance != Utils.visibleNavBarAppearance {
            navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
//            print("to visible")
        }
        
        if currentOffsetY <= tableViewInitialOffsetY && navigationController?.navigationBar.standardAppearance != Utils.transparentNavBarAppearance {
            navigationController?.navigationBar.standardAppearance = Utils.transparentNavBarAppearance
//            print("to transparent")
        }
    }

}
