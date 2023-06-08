//
//  SeriesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

// Presented on button tap: Series button in HomeViewController and category buttons in AllCategoriesViewController
class CategoryViewController: BaseViewController {
    
    private lazy var similarBooksTopView = UIView()
    private let similarBooksTopViewY: CGFloat = 1000
    private var isFirstTime = true
    
    private let networkManager = NetworkManager()
    private var books = [Int : [Book]]()
    
    deinit {
        networkManager.cancelTasks()
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBooks()
        extendedLayoutIncludesOpaqueBars = true
        
        guard let category = category else { return }
        
        // Set new table header and add stretching top view if vc is created when showMoreTitlesLikeThis BookDetailsBottomSheetCell is selected OR just configure existing table header with dim view for all other cases
        if let book = category.bookToShowMoreTitlesLikeIt {
            // Replace tableHeaderView
            let headerView = SimilarBooksTableHeaderView()
            headerView.configureFor(book: book)
            bookTable.tableHeaderView = headerView
            
            // Add stretching topView
            similarBooksTopView.backgroundColor = UIColor.powderGrayBackgroundColor
            
            bookTable.addSubview(similarBooksTopView)
            let zPosition = bookTable.layer.zPosition - 1
            similarBooksTopView.layer.zPosition = zPosition
            similarBooksTopView.frame = CGRect(origin: CGPoint(x: 0, y: -similarBooksTopViewY), size: CGSize(width: view.bounds.width, height: similarBooksTopViewY))
            
            bookTable.backgroundColor = .clear
            
            navigationController?.makeNavbarAppearance(transparent: true, withVisibleTitle: true)
        } else {
            let headerView = bookTable.tableHeaderView as? TableHeaderView
            headerView?.configureWithDimView(andText: category.title)
            navigationController?.makeNavbarAppearance(transparent: true)
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = view.bounds
        frame.size.height -= UITabBar.tabBarHeight
        bookTable.frame = frame
    }

    // MARK: - Superclass overrides
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }
        let subCategoryIndex = indexPath.section
        if let books = books[subCategoryIndex] {
            cell.configureFor(books: books, callback: dimmedAnimationButtonDidTapCallback)
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
        
        guard category?.bookToShowMoreTitlesLikeIt != nil else { return }
        
        let contentOffsetY = scrollView.contentOffset.y
        if abs(contentOffsetY) > abs(tableViewInitialOffsetY) {
            similarBooksTopView.frame.size.height = similarBooksTopViewY + abs(contentOffsetY)
        } else {
            similarBooksTopView.frame.size.height = similarBooksTopViewY + abs(tableViewInitialOffsetY)
        }
    }
    
}

// MARK: - Helper methods
extension CategoryViewController {
    private func fetchBooks() {
        guard let category = category else { return }
        let subCategories = category.subCategories
    
        for (index, subCategory) in subCategories.enumerated() {
            let subCategoryKind = subCategory.kind
//            guard subCategoryKind != .allCategoriesButton && subCategoryKind != .seriesCategoryButton else { continue }
            
            let query = subCategory.searchQuery
            networkManager.fetchBooks(withQuery: query, bookKindsToFetch: subCategory.bookKinds) { [weak self] result in
                self?.handleFetchResult(result, forSubCategoryIndex: index, andSubCategoryKind: subCategoryKind)
            }
        }
    }
    
    private func handleFetchResult(_ result: SearchResult, forSubCategoryIndex index: Int, andSubCategoryKind subCategoryKind: SubCategoryKind) {
        switch result {
        case .success(let fetchedBooks):
            self.networkManager.loadAndResizeImagesFor(books: fetchedBooks, subCategoryKind: subCategoryKind) { booksWithImages in
                self.books[index] = booksWithImages
                self.bookTable.reloadRows(at: [IndexPath(row: 0, section: index)], with: .none)
            }
        case .failure(let error):
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
