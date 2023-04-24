//
//  AllTitlesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 31/3/23.
//

import UIKit

var allTitlesBooks = Book.books + [Book.book20, Book.book21, Book.book22, Book.book23] + [Book.senorDeLosAnillos1, Book.senorDeLosAnillos2]

class AllTitlesViewController: BaseTableViewController {

    var tableSection: TableSection?
    let titleModel: Title?
            
//    private let books = Book.books + [Book.book20, Book.book21, Book.book22, Book.book23] + [Book.senorDeLosAnillos1, Book.senorDeLosAnillos2]
//    private var books = Book.books + [Book.book20, Book.book21, Book.book22, Book.book23] + [Book.senorDeLosAnillos1, Book.senorDeLosAnillos2]

//
//    private let books = [Book.book1, Book.book1, Book.book1, Book.book1,
//                         Book.book1, Book.book1, Book.book1, Book.book1,
//                         Book.book1, Book.book1, Book.book1, Book.book1,
//                         Book.book1, Book.book1, Book.book1, Book.book1]
    
    private let popupButton = PopupButton()
    private let viewWithPopupButton = UIView()
    
    private var currentSelectedBook: Book?
    
    // MARK: - Initializers
    init(tableSection: TableSection? = nil, titleModel: Title? = nil) {
        self.tableSection = tableSection
        self.titleModel = titleModel
        super.init(tableViewStyle: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBookTable()
        view.addSubview(popupButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("viewWillAppear of AllTitlesViewController")
        // This will execute when returning from BookViewController (presented when cell selected)
        guard let currentSelectedBook = currentSelectedBook else { return }

        var selectedBookIndexPath = IndexPath(row: 0, section: 0)
        for (index, book) in allTitlesBooks.enumerated() {
            if book.title == currentSelectedBook.title {
                selectedBookIndexPath.row = index
                break
            }
        }

        // This delay avoids warning that "UITableView was told to layout its visible cells and other contents without being in the view hierarchy"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.bookTable.reloadRows(at: [selectedBookIndexPath], with: .none)
        }
        #warning("Do this update only if selected book was really changed. If user doesn't tap save button, this update is not needed. Check it somehow.")
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableSection.books.count
//        return books.count
        return allTitlesBooks.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllTitlesTableViewCell.identifier, for: indexPath) as? AllTitlesTableViewCell else { return UITableViewCell() }
        
        let book = allTitlesBooks[indexPath.row]
        cell.configureWith(book: book)
        cell.saveButtonDidTapCallback = popupButton.reconfigureAndAnimateSelf
        
        cell.ellipsisButtonDidTapCallback = { [weak self] in
            // Get book from array to get correct data for saveBook cell
            let updatedBook = allTitlesBooks[indexPath.row]
            let bookDetailsBottomSheetController = BottomSheetViewController(book: updatedBook, kind: .bookDetails)
            
            bookDetailsBottomSheetController.tableViewDidSelectViewSeriesCellCallback = { [weak self] in
                guard let series = book.series else { return }
                let tableSection = TableSection(sectionTitle: series)
                    let controller = AllTitlesViewController(tableSection: tableSection, titleModel: Series.series1)
                    self?.navigationController?.pushViewController(controller, animated: true)
            }
            
            bookDetailsBottomSheetController.tableViewDidSelectShowMoreTitlesLikeThisCellCallback = { [weak self] category in
//                let controller = CategoryViewController(categoryModel: Category.librosSimilares)
                let controller = CategoryViewController(categoryModel: category)
                self?.navigationController?.pushViewController(controller, animated: true)
            }

            bookDetailsBottomSheetController.tableViewDidSelectSaveBookCellCallback = { [weak self] in
                self?.bookTable.reloadRows(at: [indexPath], with: .none)
            }
            
            bookDetailsBottomSheetController.viewStorytellersDidTapCallback = { [weak self] storytellers in
                
                if storytellers.count == 1 {
                    let controller = AllTitlesViewController(tableSection: TableSection.generalForAllTitlesVC, titleModel: storytellers.first)
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
                
                if storytellers.count > 1 {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in

                        let bottomSheetKind: BottomSheetKind = storytellers.first as? Author != nil ? .authors : .narrators
                        let storytellersBottomSheetController = BottomSheetViewController(book: book, kind: bottomSheetKind)

                        storytellersBottomSheetController.tableViewDidSelectStorytellerCallback = { [weak self] selectedStoryteller in
                            guard let self = self else { return }
                            self.dismiss(animated: false)
                            let controller = AllTitlesViewController(tableSection: TableSection.generalForAllTitlesVC, titleModel: selectedStoryteller)
                            self.navigationController?.pushViewController(controller, animated: true)
                        }

                        storytellersBottomSheetController.modalPresentationStyle = .overFullScreen
                        self?.present(storytellersBottomSheetController, animated: false)
                    }
                }
            }
            
            bookDetailsBottomSheetController.modalPresentationStyle = .overFullScreen
            self?.present(bookDetailsBottomSheetController, animated: false)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        let book = books[indexPath.row]
        let book = allTitlesBooks[indexPath.row]
        return AllTitlesTableViewCell.getEstimatedHeightForRowWith(width: view.bounds.width, andBook: book)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: AllTitlesSectionHeaderView.identifier) as? AllTitlesSectionHeaderView else {
            return UIView()
        }
        
        if let titleModel = titleModel, titleModel.titleKind == .series {
            sectionHeader.configureWith(title: "All books")
        } else {
            sectionHeader.configureWith(title: "All titles")
        }

        guard let tableSection = tableSection else { return UIView() }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRowAt")
        let book = allTitlesBooks[indexPath.row]
        currentSelectedBook = book
        
        let controller = BookViewController(book: book)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Superclass overrides
    override func configureNavBar() {
        super.configureNavBar()
        
        var text = ""
        if let author = titleModel as? Author {
            text = author.name
        } else if let narrator = titleModel as? Narrator {
            text = narrator.name
        } else if let series = titleModel as? Series {
            text = series.title
        } else if let tag = titleModel as? Tag {
            text = tag.tagTitle
        } else if let tableSection = tableSection {
            text = tableSection.sectionTitle
        }

        text = text.replacingOccurrences(of: "\n", with: " ")
        title = text

        extendedLayoutIncludesOpaqueBars = true
    }
    
//    override func adjustNavBarAppearanceTo(currentOffsetY: CGFloat) {
//        navigationController?.adjustAppearanceTo(currentOffsetY: currentOffsetY, offsetYToCompareTo: tableViewInitialOffsetY)
//    }
    
    // MARK: - Helper methods
    private func configureBookTable() {
        bookTable.allowsSelection = true
        bookTable.separatorColor = UIColor.tertiaryLabel
        bookTable.separatorInset = UIEdgeInsets(top: 0, left: Constants.cvPadding, bottom: 0, right: Constants.cvPadding)
        
        // Bottom inset is needed to avoid little table view scroll when user is at the very bottom of table view and popButton shows
        bookTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: PopupButton.buttonHeight, right: 0)
        
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
        
        if let headerView = bookTable.tableHeaderView as? TableHeaderView, let tableSection = tableSection {
            headerView.configureFor(tableSection: tableSection, titleModel: titleModel)
        }
                
//        print("   bookTable cosntraints are set")
//        bookTable.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            bookTable.topAnchor.constraint(equalTo: view.topAnchor),
//            bookTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            bookTable.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
//            bookTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Utils.tabBarHeight)
//        ])
    }

}
