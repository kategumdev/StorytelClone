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
    
//    private lazy var popupButton = PopupButton()
    private let popupButton = PopupButton()
//    private lazy var popupButtonBottomAnchor =             popupButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: popupButton.bottomAnchorConstant)

//    private lazy var showPopupCallback = { [weak self] in
//        print("showPopupCallback is executing")
//        guard let self = self else { return }
//        UIView.animate(withDuration: 0.5, animations: {
//            self.popupButtonBottomAnchor.constant = -self.popupButton.bottomAnchorConstant
//            self.view.layoutIfNeeded()
//            self.popupButton.alpha = 1
//        })
//    }
//    
//    private lazy var hidePopupCallback = { [weak self] in
//        guard let self = self else { return }
//        print("hidePopupCallback is executing")
//        UIView.animate(withDuration: 0.4, animations: {
//            self.popupButtonBottomAnchor.constant = self.popupButton.bottomAnchorConstant
//            self.view.layoutIfNeeded()
//            self.popupButton.alpha = 0
//        })
//    }
//    
//    lazy var hidePopupWorkItem = DispatchWorkItem { [weak self] in
//        self?.hidePopupCallback()
//    }
//    
//    private lazy var showPopupWorkItem = DispatchWorkItem { [weak self] in
//        self?.showPopupCallback()
//    }
//    
//    private lazy var togglePopupButtonTextCallback = { [weak self] userAddedBookToBookshelf in
//        guard let self = self else { return }
//        self.popupButton.changeLabelTextWhen(bookIsAdded: userAddedBookToBookshelf)
//    }
//    
//    private lazy var saveButtonTappedCallback = { [weak self]
//        userAddedBookToBookshelf in
//        guard let self = self else { return }
//        self.cancelAndReassignWorkItems()
//        
//        // If popupView is already visible, hide it to enable animation in showPopupWorkItem
//        if self.popupButtonBottomAnchor.constant < self.popupButton.bottomAnchorConstant {
//            self.popupButtonBottomAnchor.constant = self.popupButton.bottomAnchorConstant
//            self.view.layoutIfNeeded()
//        }
//        
//        UIView.animate(withDuration: 0.6, animations: { [weak self] in
//            guard let self = self else { return }
//            self.togglePopupButtonTextCallback(userAddedBookToBookshelf)
//            
//            DispatchQueue.main.async(execute: self.showPopupWorkItem)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: self.hidePopupWorkItem)
//        })
//        
//    }
    
    // MARK: - View life cycle
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
        view.addSubview(popupButton)
        popupButton.applyConstraints()
//        popupButton.applyButtonConstraints()
        
//        addPopupButtonAction()
//        applyConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = view.bounds
        frame.size.height = view.bounds.height - Utils.tabBarHeight
        bookTable.frame = frame
    }
    
    
    // MARK: - Helper methods
    private func configureBookTable() {
        bookTable.separatorColor = UIColor.tertiaryLabel
        bookTable.separatorInset = UIEdgeInsets(top: 0, left: Constants.cvPadding, bottom: 0, right: Constants.cvPadding)

        // Hide separator line under the last cell
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: bookTable.bounds.width, height: 1))
        footerView.backgroundColor = .clear
        bookTable.tableFooterView = footerView
        
        // Reset insets set in superclass
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
    
//    private func addPopupButtonAction() {
//        popupButton.addAction(UIAction(handler: { [weak self] _ in
//            guard let self = self else { return }
//            // Cancel the work item to prevent it from executing with the delay
//            self.hidePopupWorkItem.cancel()
//
//            // Execute the callback immediately
//            self.hidePopupCallback()
//
//            // Reassign workItem to replace the cancelled one
//            self.hidePopupWorkItem = DispatchWorkItem { [weak self] in
//                self?.hidePopupCallback()
//            }
//        }), for: .touchUpInside)
//    }
//    
//    private func cancelAndReassignWorkItems() {
//        showPopupWorkItem.cancel()
//        hidePopupWorkItem.cancel()
//        
//        showPopupWorkItem = DispatchWorkItem { [weak self] in
//            self?.showPopupCallback()
//        }
//        
//        hidePopupWorkItem = DispatchWorkItem { [weak self] in
//            self?.hidePopupCallback()
//        }
//    }
    
//    private func applyConstraints() {
//        // Configure popupButton constraints
//        popupButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            popupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.cvPadding),
//            popupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.cvPadding),
//            popupButton.heightAnchor.constraint(equalToConstant: 46)
//        ])
//        popupButtonBottomAnchor.isActive = true
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
        
//        cell.configureFor(book: book, saveButtonTappedCallback: saveButtonTappedCallback)
        cell.configureFor(book: book, saveButtonTappedCallback: popupButton.saveButtonTappedCallback)

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
    
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let calculatedHeight = AllTitlesSectionHeaderView.calculateEstimatedHeaderHeight()
//
//        return calculatedHeight
////        return 40
//    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // Hide separator line under the last cell
//        if indexPath.row == books.count - 1 {
//            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width / 2, bottom: 0, right: cell.bounds.width / 2)
//        } else {
//            cell.separatorInset = UIEdgeInsets(top: 0, left: Constants.cvPadding, bottom: 0, right: Constants.cvPadding)
//        }
//    }

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
