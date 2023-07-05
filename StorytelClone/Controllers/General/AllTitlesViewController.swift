//
//  AllTitlesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 31/3/23.
//

import UIKit

var allTitlesBooks = Book.books + [Book.book20, Book.book21, Book.book22, Book.book23] + [Book.senorDeLosAnillos1, Book.senorDeLosAnillos2]

class AllTitlesViewController: BaseViewController {

    var subCategory: SubCategory?
    let titleModel: Title?
    private var books = [Book]()
    
    private let popupButton = PopupButton()
    private var isHeaderConfigured = false
    
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        return view
    }()

    // MARK: - Initializers
    init(subCategory: SubCategory? = nil, titleModel: Title? = nil, books: [Book] = [Book]()) {
        self.subCategory = subCategory
        self.titleModel = titleModel
        self.books = books
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !didAppearFirstTime else {
            didAppearFirstTime = false
            return
        }
        bookTable.reloadData()
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllTitlesTableViewCell.identifier, for: indexPath) as? AllTitlesTableViewCell else { return UITableViewCell() }
        
        let book = books[indexPath.row]
        cell.configureWith(book: book)
        cell.saveBookButtonDidTapCallback = popupButton.reconfigureAndAnimateSelf

        cell.ellipsisButtonDidTapCallback = { [weak self] in
            guard let self = self else { return }
            // Get the latest updated book model object
            let updatedBook = self.books[indexPath.row]
            
            let bookDetailsBottomSheetController = BottomSheetViewController(book: updatedBook, kind: .bookDetails)
            bookDetailsBottomSheetController.delegate = self
            bookDetailsBottomSheetController.modalPresentationStyle = .overFullScreen
            self.present(bookDetailsBottomSheetController, animated: false)
        }
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
        guard !books.isEmpty, let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: AllTitlesSectionHeaderView.identifier) as? AllTitlesSectionHeaderView, let subCategory = subCategory else { return nil }
        
        let titleText = titleModel?.titleKind == .series ? "All books" : "All titles"
        sectionHeader.configureWith(title: titleText)
        
        if subCategory.canBeFiltered && subCategory.canBeShared {
            sectionHeader.showShareAndFilterButtons()
        } else if subCategory.canBeFiltered {
            sectionHeader.showOnlyFilterButton()
        } else {
            sectionHeader.showOnlyShareButton()
        }
        return sectionHeader
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard books.isEmpty else { return }
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let calculatedHeight = AllTitlesSectionHeaderView.calculateEstimatedHeaderHeight()
        return calculatedHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        let controller = BookViewController(book: book)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Superclass overrides
    override func configureNavBar() {
        super.configureNavBar()
        var text = ""
        if let storyteller = titleModel as? Storyteller {
            text = storyteller.name
        } else if let series = titleModel as? Series {
            text = series.title
        } else if let tag = titleModel as? Tag {
            text = tag.tagTitle
        } else if let subCategory = subCategory {
            text = subCategory.title
        }

        text = text.replacingOccurrences(of: "\n", with: " ")
        title = text
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func layoutTableHeader() {
        if networkManager.hasError {
            bookTable.tableHeaderView = nil
        } else {
            configureAndLayoutTableHeader()
        }
    }

    // MARK: - Helper methods
    private func configureBookTable() {
        bookTable.allowsSelection = true
        bookTable.separatorColor = UIColor.tertiaryLabel
        bookTable.separatorInset = UIEdgeInsets(top: 0, left: Constants.commonHorzPadding, bottom: 0, right: Constants.commonHorzPadding)
        
        // Bottom inset is needed to avoid little table view scroll when user is at the very bottom of table view and popButton shows
        bookTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: PopupButton.buttonHeight, right: 0)
        
        // Hide tableFooterView
        bookTable.tableFooterView?.frame.size.height = 0.1

        bookTable.register(AllTitlesSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: AllTitlesSectionHeaderView.identifier)
        bookTable.register(AllTitlesTableViewCell.self, forCellReuseIdentifier: AllTitlesTableViewCell.identifier)
    }
    
    // Code from this func will be called in BaseVC's viewDidLayoutSubviews, so that it's called twice (it is needed for correct header layout)
    private func configureAndLayoutTableHeader() {
        if let storyteller = titleModel as? Storyteller {
            let headerView = PersonTableHeaderView(kind: .forStoryteller(storyteller: storyteller, superviewWidth: bookTable.bounds.width))
            bookTable.tableHeaderView = headerView
            Utils.layoutTableHeaderView(headerView, inTableView: bookTable)
            return
        }
        
        guard let headerView = bookTable.tableHeaderView as? TableHeaderView, let subCategory = subCategory else { return }
        if !isHeaderConfigured {
            headerView.configureFor(subCategory: subCategory, titleModel: titleModel)
            isHeaderConfigured = true
        }
        Utils.layoutTableHeaderView(headerView, inTableView: bookTable)
    }
    
    override func fetchBooks() {
        // Avoid fetching books if they are set in vc's init (seeAllButton tapped)
        guard books.isEmpty else { return }

        // Fetch data for vc with .author titleModel
        let modelKind = titleModel?.titleKind
        guard modelKind == .author, let author = titleModel as? Storyteller else {
            books = allTitlesBooks // hardcoded data for all other cases
            return
        }

        let query = author.name.trimmingCharacters(in: .whitespaces)
        activityIndicator.startAnimating()
        networkManager.fetchBooks(withQuery: query, bookKindsToFetch: .ebooksAndAudiobooks) { [weak self] result in
            self?.handleFetchResult(result)
        }
    }
    
    private func handleFetchResult(_ result: SearchResult) {
        switch result {
        case .success(let fetchedBooks):
            books = fetchedBooks
            books.shuffle()

            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.bookTable.reloadData()
            }
        case .failure(let error):
            if let networkError = error as? NetworkManagerError {
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.stopAnimating()
                    let noBooksView = NoDataBackgroundView(kind: .networkingError(error: networkError))
                    self?.bookTable.backgroundView = noBooksView
                }
            }
        }
    }
    
}

extension AllTitlesViewController: BottomSheetViewControllerDelegate {
    func bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook book: Book) {
        var indexPathOfRowWithThisBook = IndexPath(row: 0, section: 0)
        for (index, arrayBook) in books.enumerated() {
            if arrayBook == book {
                indexPathOfRowWithThisBook.row = index
                break
            }
        }
        self.bookTable.reloadRows(at: [indexPathOfRowWithThisBook], with: .none)
    }

}
