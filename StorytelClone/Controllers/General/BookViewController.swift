//
//  BookViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

class BookViewController: UIViewController {
    // MARK: - Instance properties
    let book: Book
    private lazy var bookContainerScrollView = BookContainerScrollView(book: book, superviewWidth: view.bounds.width)
    private let popupButton: PopupButton
    private var scrollViewInitialOffsetY: CGFloat?
    private var isDidAppearTriggeredFirstTime = true
    private let networkManager: any NetworkManager
    private let imageDownloader: any ImageDownloader
    private var similarBooks = [Book]()
        
    // MARK: - Initializers
    init(book: Book, networkManager: some NetworkManager = AlamofireNetworkManager(), popupButton: some PopupButton = DefaultPopupButton(), imageDownloader: some ImageDownloader = DefaultSDWebImageDownloader()) {
        self.book = book
        self.networkManager = networkManager
        self.popupButton = popupButton
        self.imageDownloader = imageDownloader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customBackgroundColor
        addBookContainerScrollView()
        configureNavBar()
        fetchSimilarBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustNavBarAppearanceFor(currentOffsetY: bookContainerScrollView.bookTable.contentOffset.y)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard isDidAppearTriggeredFirstTime else {
            bookContainerScrollView.bookDetailsStackView.updateSaveButtonAppearance()
            return
        }
        isDidAppearTriggeredFirstTime = false
        addPopupButton()
        addHideView()
        passCallbacksToBookContainerScrollView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bookContainerScrollView.playSampleButtonContainer.stopPlaying()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension BookViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }

        let callback: DimmedAnimationBtnDidTapCallback = { [weak self] controller in
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        cell.configureFor(books: similarBooks, callback: callback)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView else { return UIView() }
        
        sectionHeader.configureFor(subCategory: SubCategory.similarTitles) { [weak self] in
            guard let self = self else { return }
            let controller = AllTitlesViewController(subCategory: SubCategory.similarTitles, books: self.similarBooks)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        return sectionHeader
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        guard scrollViewInitialOffsetY != nil else {
            scrollViewInitialOffsetY = currentOffsetY
            return
        }
        // Toggle navbar from transparent to visible (and vice versa) as needed
        adjustNavBarAppearanceFor(currentOffsetY: currentOffsetY)
    }
}

// MARK: - Helper methods
extension BookViewController {
    private func addBookContainerScrollView() {
        view.addSubview(bookContainerScrollView)
        bookContainerScrollView.applyConstraints()
        bookContainerScrollView.delegate = self
        bookContainerScrollView.bookTable.dataSource = self
        bookContainerScrollView.bookTable.delegate = self
    }
    
    private func passCallbacksToBookContainerScrollView() {
        bookContainerScrollView.bookDetailsScrollView.categoryButtonDidTapCallback = { [weak self] in
            guard let self = self else { return }
            let category = self.book.category
            let controller = CategoryViewController(category: category)
            self.navigationController?.pushViewController(controller, animated: true)
        }
     
        bookContainerScrollView.bookDetailsStackView.storytellerButtonDidTapCallback = { [weak self] storytellers in
            guard let self = self else { return }
            if storytellers.count == 1 {
                let controller = AllTitlesViewController(subCategory: SubCategory.generalForAllTitlesVC, titleModel: storytellers.first)
                self.navigationController?.pushViewController(controller, animated: true)
                return
            }
            
            // For cases when storytellers.count > 1
            let storytellersBottomSheetController = BottomSheetViewController(book: self.book, kind: .storytellers(storytellers: storytellers))
            storytellersBottomSheetController.delegate = self
            storytellersBottomSheetController.modalPresentationStyle = .overFullScreen
            self.present(storytellersBottomSheetController, animated: false)
        }
        
        if bookContainerScrollView.hasTags {
            bookContainerScrollView.tagsView.tagButtonDidTapCallback = { [weak self] tag in
                guard let self = self else { return }
                let controller = AllTitlesViewController(subCategory: SubCategory.generalForAllTitlesVC, titleModel: tag)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        guard book.series != nil else { return }
        bookContainerScrollView.bookDetailsStackView.showSeriesButtonDidTapCallback = { [weak self] in
            guard let self = self, let series = self.book.series else { return }
            let subCategory = SubCategory(title: series, searchQuery: "\(series)")
            let controller = AllTitlesViewController(subCategory: subCategory, titleModel: Series.series1)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }

    private func adjustNavBarAppearanceFor(currentOffsetY: CGFloat) {
        guard let scrollViewInitialOffsetY = scrollViewInitialOffsetY else { return }
        let offsetYToCompareTo = scrollViewInitialOffsetY + bookContainerScrollView.maxYOfBookTitleLabel
        navigationController?.adjustAppearanceTo(currentOffsetY: currentOffsetY, offsetYToCompareTo: offsetYToCompareTo)
    }
    
    private func addPopupButton() {
        view.addSubview(popupButton)
        bookContainerScrollView.bookDetailsStackView.saveBookButtonDidTapCallback = popupButton.reconfigureAndAnimateSelf
    }
    
    // Cover "compressed" part of bookOverviewStackView in order to not see it if it's high and shows below bookTable on scroll to the very bottom of bookContainerScrollView
    private func addHideView() {
        let hideView = UIView()
        view.addSubview(hideView)
        hideView.backgroundColor = UIColor.customBackgroundColor
        hideView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 1000 ensures that hidden parts of overviewStackView and tagsView (if present) are fully covered by hideView
            hideView.heightAnchor.constraint(equalToConstant: 1000.0),
            hideView.widthAnchor.constraint(equalTo: view.widthAnchor),
            hideView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hideView.topAnchor.constraint(equalTo: bookContainerScrollView.bookTable.bottomAnchor)
        ])
    }
    
    private func configureNavBar() {
        title = book.title
        navigationController?.makeAppearance(transparent: true)
        navigationItem.backButtonTitle = ""
        extendedLayoutIncludesOpaqueBars = true
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .heavy)
        let image = UIImage(systemName: "ellipsis", withConfiguration: symbolConfig)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(ellipsisButtonDidTap))
    }
    
    @objc func ellipsisButtonDidTap() {
        // Get the latest updated book model object
        var updatedBook: Book = book
        for book in allTitlesBooks {
            if book.title == self.book.title {
                updatedBook = book
                break
            }
        }
        let bookDetailsBottomSheetController = BottomSheetViewController(book: updatedBook, kind: .bookDetails)
        bookDetailsBottomSheetController.delegate = self
        bookDetailsBottomSheetController.modalPresentationStyle = .overFullScreen
        self.present(bookDetailsBottomSheetController, animated: false)
    }
    
    private func fetchSimilarBooks() {
        // Query is hardcoded for now
        networkManager.fetchBooks(withQuery: "dark", bookKindsToFetch: .ebooksAndAudiobooks) { [weak self] result in
            self?.handleFetchResult(result)
        }
    }
    
    private func handleFetchResult(_ result: SearchResult) {
        switch result {
        case .success(let fetchedBooks):
            self.imageDownloader.downloadAndResizeImagesFor(books: fetchedBooks, subCategoryKind: .horzCv) { [weak self] booksWithImages in
                self?.similarBooks = booksWithImages
                self?.bookContainerScrollView.bookTable.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none) // reloadRows() used instead of reloadData() to avoid forcing layout of table view when it's not onscreen yet
            }
        case .failure(let error):
            self.networkManager.cancelRequests()
            if error is NetworkManagerError {
                DispatchQueue.main.async {
#warning("show error background view")
                }
            }
        }
    }
}

// MARK: - BottomSheetViewControllerDelegate
extension BookViewController: BottomSheetViewControllerDelegate {
    func bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook book: Book) {
        bookContainerScrollView.bookDetailsStackView.updateSaveButtonAppearance()
    }
}
