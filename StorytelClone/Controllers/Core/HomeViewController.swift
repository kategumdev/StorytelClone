//
//  ViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit
import SDWebImage

class HomeViewController: BaseViewController {
    
    private var books = [Int : [Book]]()
    private let networkManager = NetworkManager()
    private let popupButton = PopupButton()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        loadBooks()
        view.addSubview(popupButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustNavBarAppearanceTo(currentOffsetY: bookTable.contentOffset.y)
        
        if let tableHeader = bookTable.tableHeaderView as? TableHeaderView {
            tableHeader.updateGreetingsLabel()
        }
    }
    
    override func viewDidLayoutSubviews() {
        bookTable.frame = view.bounds
        guard let tableHeader = bookTable.tableHeaderView as? TableHeaderView else { return }
        tableHeader.stackTopAnchorConstraint.constant = 15
        tableHeader.stackBottomAnchorConstraint.constant = 0
        tableHeader.updateGreetingsLabel()
        layoutTableHeader()
    }
    
    // MARK: - Superclass overrides
    override func configureNavBar() {
        super.configureNavBar()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let image = UIImage(systemName: "bell", withConfiguration: symbolConfig)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        title = "Home"
        extendedLayoutIncludesOpaqueBars = true
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("section \(indexPath.row)")
        guard let category = category else { return UITableViewCell() }
        let subCategoryKind = category.subCategories[indexPath.section].kind

        switch subCategoryKind {
        case .horizontalCv: return cellWithHorizontalCv(in: tableView, for: indexPath)
        case .verticalCv: return UITableViewCell()
        case .oneBookWithOverview: return bookWithOverviewCell(in: tableView, for: indexPath)
        case .poster: return posterCell(in: tableView, for: indexPath)
        case .largeCoversHorizontalCv: return cellWithLargeCoversHorizontalCv(in: tableView, for: indexPath)
        case .seriesCategoryButton: return wideButtonCell(in: tableView, for: indexPath)
        case .allCategoriesButton: return wideButtonCell(in: tableView, for: indexPath)
        case .searchVc: return UITableViewCell()
        }
        #warning("cells for verticalCv and searchVc not needed, refactor them somewhere else")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let category = category else { return 0 }
        let subCategoryKind = category.subCategories[indexPath.section].kind
        
        switch subCategoryKind {
        case .horizontalCv: return TableViewCellWithCollection.rowHeight
        case .verticalCv: return 0
        case .oneBookWithOverview:
            let book = category.subCategories[indexPath.section].books[0]
            return BookWithOverviewTableViewCell.calculateHeightForRow(withBook: book)
            
        case .poster: return PosterTableViewCell.heightForRow
        case .largeCoversHorizontalCv: return TableViewCellWithHorzCvLargeRectangleCovers.rowHeight
        case .seriesCategoryButton: return WideButtonTableViewCell.rowHeight
        case .allCategoriesButton: return WideButtonTableViewCell.rowHeight
        case .searchVc: return 0
        }
        #warning("cases verticalCv and searchVc not needed here, refactor them somewhere else")
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let category = category else { return 0 }
        let subCategoryKind = category.subCategories[section].kind
        
        if subCategoryKind == .seriesCategoryButton || subCategoryKind == .allCategoriesButton {
            return SectionHeaderView.topPadding
        } else {
            return UITableView.automaticDimension
        }
    }

}

// MARK: - Helper methods
extension HomeViewController {
    private func configureTable() {
        bookTable.register(WideButtonTableViewCell.self, forCellReuseIdentifier: WideButtonTableViewCell.identifier)
        bookTable.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.identifier)
        bookTable.register(TableViewCellWithHorzCvLargeRectangleCovers.self, forCellReuseIdentifier: TableViewCellWithHorzCvLargeRectangleCovers.identifier)
        bookTable.register(BookWithOverviewTableViewCell.self, forCellReuseIdentifier: BookWithOverviewTableViewCell.identifier)
        
        // Bottom inset is needed to avoid little table view scroll when user is at the very bottom of table view and popButton shows
        bookTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: PopupButton.buttonHeight, right: 0)
    }
    
    private func loadBooks() {
        guard let category = category else { return }
        let subCategories = category.subCategories
    
        // Add indices of categories to books dict
        for (index, subCategory) in subCategories.enumerated() {
            let kind = subCategory.kind
            guard kind != .allCategoriesButton && kind != .seriesCategoryButton else { continue }
            
            let query = subCategory.searchQuery
            networkManager.fetchBooks(withQuery: query, bookKindsToFetch: subCategory.bookKinds) { [weak self] result in
                guard let self = self else { return }
//                print("networkManager of HomeVC fetches for \(query), kind \(kind)")
                switch result {
                case .success(let fetchedBooks):
                    if kind == .poster, let book = fetchedBooks.first {
                        self.loadAndResizeImageForPoster(book: book, ofSubCategoryWithIndex: index)
                    } else {
                        self.loadAndResizeImagesFor(books: fetchedBooks, ofSubCategoryWithIndex: index, subCategoryKind: kind)
                    }
                case .failure(let error):
                    print("ERROR fetching query \(query)")
                    self.networkManager.cancelTasks()
                    if let networkError = error as? NetworkManagerError {
                        DispatchQueue.main.async {
                            #warning("show error background view")
//                            self.noBooksView = NoDataBackgroundView(kind: .networkingError(error: networkError))
//                            if let noBooksView = self.noBooksView {
//                                noBooksView.backgroundColor = UIColor.customBackgroundColor
//                                self.bookTable.addSubview(noBooksView)
//                                self.bookTable.isScrollEnabled = false
//                                noBooksView.frame = self.bookTable.bounds
//                            }
                        }
                    }
                }
            }
        }
    }
    
    private func loadAndResizeImagesFor(books: [Book], ofSubCategoryWithIndex index: Int, subCategoryKind: SubCategoryKind) {
        let downloadTaskGroup = DispatchGroup()
        var booksWithImages = [Book]() // it will contain only books that have downloaded images
        
        for book in books {
            if let imageURLString = book.imageURLString, let imageURL = URL(string: imageURLString) {
                downloadTaskGroup.enter()
                SDWebImageDownloader.shared.downloadImage(with: imageURL) { image, data, error, success in
                    if let image = image {
                        var targetHeight: CGFloat
                        if subCategoryKind == .horizontalCv {
                            targetHeight = Constants.largeSquareBookCoverSize.height
                        } else {
                            // for sub category with large rectangle covers
                            targetHeight = TableViewCellWithHorzCvLargeRectangleCovers.itemSize.height
                        }
                        let resizedImage = image.resizeFor(targetHeight: targetHeight, andSetAlphaTo: 1)
//                        let resizedImage = image.resizeFor(targetHeight: Constants.largeSquareBookCoverSize.height, andSetAlphaTo: 1)
                        var bookWithImage = book
                        bookWithImage.coverImage = resizedImage
                        booksWithImages.append(bookWithImage)
                    }
                    downloadTaskGroup.leave()
                }
            }
        }
        downloadTaskGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            booksWithImages.shuffle()
            self.books[index] = booksWithImages
            self.bookTable.reloadRows(at: [IndexPath(row: 0, section: index)], with: .none)
        }
    }
    
//    private func loadAndResizeImagesFor(books: [Book], ofSubCategoryWithIndex index: Int) {
//        let downloadTaskGroup = DispatchGroup()
//        var booksWithImages = [Book]() // it will contain only books that have downloaded images
//
//        for book in books {
//            if let imageURLString = book.imageURLString, let imageURL = URL(string: imageURLString) {
//                downloadTaskGroup.enter()
//                SDWebImageDownloader.shared.downloadImage(with: imageURL) { image, data, error, success in
//                    if let image = image {
//                        let resizedImage = image.resizeFor(targetHeight: Constants.largeSquareBookCoverSize.height, andSetAlphaTo: 1)
//                        var bookWithImage = book
//                        bookWithImage.coverImage = resizedImage
//                        booksWithImages.append(bookWithImage)
//                    }
//                    downloadTaskGroup.leave()
//                }
//            }
//        }
//        downloadTaskGroup.notify(queue: DispatchQueue.main) { [weak self] in
//            guard let self = self else { return }
//            booksWithImages.shuffle()
//            self.books[index] = booksWithImages
//            self.bookTable.reloadRows(at: [IndexPath(row: 0, section: index)], with: .none)
//        }
//    }
    
    private func loadAndResizeImageForPoster(book: Book, ofSubCategoryWithIndex index: Int) {
        if let imageURLString = book.imageURLString, let imageURL = URL(string: imageURLString) {
            SDWebImageDownloader.shared.downloadImage(with: imageURL) { [weak self] image, data, error, success in
                if let image = image {
                    let resizedImage = image.resizeFor(targetHeight: PosterTableViewCell.calculatedButtonHeight, andSetAlphaTo: 1)
                    var bookWithImage = book
                    bookWithImage.coverImage = resizedImage
                    self?.books[index] = [bookWithImage]
                    
                    DispatchQueue.main.async {
                        self?.bookTable.reloadRows(at: [IndexPath(row: 0, section: index)], with: .none)
                    }
                }
            }
        }
    }

    private func wideButtonCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WideButtonTableViewCell.identifier, for: indexPath) as? WideButtonTableViewCell else { return UITableViewCell()}
        if let category = category {
            cell.configureFor(subCategoryKind: category.subCategories[indexPath.section].kind, withCallback: dimmedAnimationButtonDidTapCallback)
        }
        return cell
    }
    
    private func posterCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PosterTableViewCell.identifier, for: indexPath) as? PosterTableViewCell else { return UITableViewCell()}
        let subCategoryIndex = indexPath.section
        if let book = books[subCategoryIndex]?.first {
            cell.configureFor(book: book, withCallback: dimmedAnimationButtonDidTapCallback)
        }
         return cell
    }
    
    private func cellWithHorizontalCv(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }
        let subCategoryIndex = indexPath.section
        if let books = books[subCategoryIndex] {
            cell.configureFor(books: books, callback: dimmedAnimationButtonDidTapCallback)
        }
        return cell
    }
    
    private func cellWithLargeCoversHorizontalCv(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithHorzCvLargeRectangleCovers.identifier, for: indexPath) as? TableViewCellWithHorzCvLargeRectangleCovers else { return UITableViewCell()}
        let subCategoryIndex = indexPath.section
        if let books = books[subCategoryIndex] {
            cell.configureWith(books: books, callback: dimmedAnimationButtonDidTapCallback)
        }
        return cell
    }
    
    private func bookWithOverviewCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookWithOverviewTableViewCell.identifier, for: indexPath) as? BookWithOverviewTableViewCell else { return UITableViewCell() }
        let subCategoryIndex = indexPath.section
        if let book = books[subCategoryIndex]?.first {
            cell.configureFor(book: book, withCallbackForDimmedAnimationButton: dimmedAnimationButtonDidTapCallback, withCallbackForSaveButton: popupButton.reconfigureAndAnimateSelf)
        }
         return cell
    }

}
