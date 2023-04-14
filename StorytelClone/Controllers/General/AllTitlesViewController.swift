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
    
//    private var isBookTableFrameSet = false
    private var timesDidLayoutSubviewsCalled = 1
    
    private var savedFrame: CGRect?
    
    private let books = Book.books + [Book.book20, Book.book21, Book.book22, Book.book23] + [Book.senorDeLosAnillos1, Book.senorDeLosAnillos2]
//    private let books = [Book.book1, Book.book1, Book.book1, Book.book1,
//                         Book.book1, Book.book1, Book.book1, Book.book1,
//                         Book.book1, Book.book1, Book.book1, Book.book1,
//                         Book.book1, Book.book1, Book.book1, Book.book1]
    
    private let popupButton = PopupButton()
    private let viewWithPopupButton = UIView()
    
    // MARK: - Initializers
    init(tableSection: TableSection, categoryOfParentVC: Category, titleModel: Title?) {
        self.tableSection = tableSection
        self.titleModel = titleModel
        super.init(categoryModel: categoryOfParentVC, tableViewStyle: .plain)
        #warning("This category is not needed in this vc, only needed for BaseTableViewController initializer")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBookTable()
//        addViewWithPopupButton()
        view.addSubview(popupButton)
//        bookTable.addSubview(popupButton)
//        bookTable.tableFooterView?.addSubview(popupButton)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        print("viewDidLayoutSubviews, view.bounds = \(view.bounds), bookTable.bounds = \(bookTable.bounds)")
//        if savedFrame == nil {
//            var frame = view.bounds
//            frame.size.height = frame.height - Utils.tabBarHeight
//            savedFrame = frame
//        }
//
//        if let savedFrame = savedFrame {
//            bookTable.frame = savedFrame
//        }
//
//        bookTable.backgroundColor = .green
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews, view.bounds = \(view.bounds), bookTable.bounds = \(bookTable.bounds)")
        var frame = view.bounds
//        frame.size.height = view.bounds.height - Utils.tabBarHeight
        frame.size.height -= Utils.tabBarHeight
        frame.size.height += PopupButton.bottomAnchorConstantForVisibleState // This line and bottom contentInset of bookTable are needed to avoid little table view scroll when user is at the very bottom of table view and popButton shows
//        frame.size.height -= Utils.tabBarHeight - PopupButton.buttonHeight
        
//        bookTable.frame = frame
        bookTable.backgroundColor = .green
//        bookTable.frame = view.bounds
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        if timesDidLayoutSubviewsCalled < 3 {
//            print("bookTableFrameSet is being called")
//            var frame = view.bounds
//            frame.size.height = view.bounds.height - Utils.tabBarHeight
//            bookTable.frame = frame
//            timesDidLayoutSubviewsCalled += 1
//        }
//    }
    
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
        
        let book = books[indexPath.row]
        cell.configureFor(book: book, popupButtonCallback: popupButton.reconfigureAndAnimateSelf)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let book = books[indexPath.row]
        return AllTitlesTableViewCell.getEstimatedHeightForRowWith(width: view.bounds.width, andBook: book)
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
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let calculatedHeight = AllTitlesSectionHeaderView.calculateEstimatedHeaderHeight()
        return calculatedHeight
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
        
        text = text.replacingOccurrences(of: "\n", with: " ")
        title = text
        
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func adjustNavBarAppearanceTo(currentOffsetY: CGFloat) {
        navigationController?.adjustAppearanceTo(currentOffsetY: currentOffsetY, offsetYToCompareTo: tableViewInitialOffsetY)
    }
    
    // MARK: - Helper methods
    private func configureBookTable() {
        bookTable.separatorColor = UIColor.tertiaryLabel
        bookTable.separatorInset = UIEdgeInsets(top: 0, left: Constants.cvPadding, bottom: 0, right: Constants.cvPadding)
        
        // Bottom inset needed to avoid little table view scroll when user is at the very bottom of table view and popButton shows
        bookTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: PopupButton.buttonHeight, right: 0)
//        bookTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: PopupButton.bottomAnchorConstantForVisibleState, right: 0)

        
        // Hide separator line under the last cell
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: bookTable.bounds.width, height: 1))
//        footerView.backgroundColor = .clear
//        bookTable.tableFooterView = footerView
        
        // Hide tableFooterView
        bookTable.tableFooterView?.frame.size.height = 0.1

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
        
        if let headerView = bookTable.tableHeaderView as? TableHeaderView {
            headerView.configureFor(tableSection: tableSection, titleModel: titleModel)
        }
                
        bookTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookTable.topAnchor.constraint(equalTo: view.topAnchor),
//            bookTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bookTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bookTable.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            bookTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Utils.tabBarHeight) // Use this instead of the one below if    extendedLayoutIncludesOpaqueBars = true
//            bookTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(Utils.tabBarHeight + PopupButton.bottomAnchorConstantForVisibleState))
//            bookTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Utils.tabBarHeight)

//            bookTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//            bookTable.bottomAnchor.constraint(equalTo: tabBar.topAnchor)
        ])
        
    }

}
