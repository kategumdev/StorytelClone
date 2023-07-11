//
//  BaseViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Instance properties
    var category: Category?
    var booksDict = [Int : [Book]]()
    private let imageDownloader: any ImageDownloader
    let networkManager: any NetworkManager
    let tableViewStyle: UITableView.Style
    
    var tableViewInitialOffsetY: Double = 0
    var isInitialOffsetYSet = false
    private var previousContentSize: CGSize = CGSize(width: 0, height: 0)
    private var lastVisibleRowIndexPath = IndexPath(row: 0, section: 0)
    private var didLayoutSubviewsFirstTime = true
    var didAppearFirstTime = true
    
    lazy var bookTable: UITableView = {
        let table = UITableView(frame: .zero, style: tableViewStyle)
        table.backgroundColor = UIColor.customBackgroundColor
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
        table.allowsSelection = false
        
        table.register(TableViewCellWithCollection.self, forCellReuseIdentifier: TableViewCellWithCollection.identifier)
        table.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        
        table.sectionFooterHeight = 0 // Avoid gaps between sections and custom section headers
        table.sectionHeaderTopPadding = 0 // Avoid gap above custom section header

        // Avoid gap at the very bottom of the table view
        table.tableFooterView = UIView()
        table.tableFooterView?.frame.size.height = SectionHeaderView.topPadding
        return table
    }()
     
    lazy var dimmedAnimationButtonDidTapCallback: DimmedAnimationButtonDidTapCallback = { [weak self] controller in
        self?.navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: - Initializers
    init(categoryModel: Category? = nil, tableViewStyle: UITableView.Style = .grouped, networkManager: some NetworkManager = AlamofireNetworkManager(), imageDownloader: some ImageDownloader = DefaultSDWebImageDownloader()) {
        self.category = categoryModel
        self.tableViewStyle = tableViewStyle
        self.networkManager = networkManager
        self.imageDownloader = imageDownloader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if !(self is AllCategoriesViewController) {
            fetchBooks()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustNavBarAppearanceTo(currentOffsetY: bookTable.contentOffset.y)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bookTable.frame = view.bounds
        layoutTableHeader()
        
        guard didLayoutSubviewsFirstTime == true else { return }
        didLayoutSubviewsFirstTime = false
        // Force vc to call viewDidLayoutSubviews second time to correctly layout table header
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    // MARK: - Helper methods
    private func setupUI() {
        view.backgroundColor = UIColor.customBackgroundColor
        view.addSubview(bookTable)
        bookTable.delegate = self
        bookTable.dataSource = self
        bookTable.tableHeaderView = TableHeaderView()
        configureNavBar()
    }
    
    func fetchBooks() {
        guard let category = category else { return }
        let subCategories = category.subCategories
    
        for (index, subCategory) in subCategories.enumerated() {
            let subCategoryKind = subCategory.kind
            guard subCategoryKind != .allCategoriesButton && subCategoryKind != .seriesCategoryButton else { continue }
            
            let query = subCategory.searchQuery
            networkManager.fetchBooks(withQuery: query, bookKindsToFetch: subCategory.bookKinds) { [weak self] result in
                self?.handleFetchResult(result, forSubCategoryIndex: index, andSubCategoryKind: subCategoryKind)
            }
        }
    }
    
    func handleFetchResult(_ result: SearchResult, forSubCategoryIndex index: Int, andSubCategoryKind subCategoryKind: SubCategoryKind) {
        switch result {
        case .success(let fetchedBooks):
            self.imageDownloader.downloadAndResizeImagesFor(books: fetchedBooks, subCategoryKind: subCategoryKind) { booksWithImages in
                
                // Save images into a dict to use their sizes for calculating the item size of the collection view that will eventually display the images
                self.booksDict[index] = booksWithImages
                self.bookTable.reloadRows(at: [IndexPath(row: 0, section: index)], with: .none)
            }
        case .failure(let error):
            self.networkManager.cancelRequests()
            self.imageDownloader.cancelDownloads()
            if error is NetworkManagerError {
                DispatchQueue.main.async {
#warning("show error background view")
                }
            }
        }
    }
    
    func configureNavBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.makeAppearance(transparent: true)
        navigationItem.backButtonTitle = ""
    }
    
    func adjustNavBarAppearanceTo(currentOffsetY: CGFloat) {
        var offsetYToCompareTo: CGFloat = tableViewInitialOffsetY
        
        if self is AllCategoriesViewController {
            if let tableHeaderHeight = bookTable.tableHeaderView?.bounds.size.height {
                offsetYToCompareTo = tableViewInitialOffsetY + tableHeaderHeight + 10
                changeHeaderDimViewAlphaWith(currentOffsetY: currentOffsetY)
            }
        }
        
        navigationController?.adjustAppearanceTo(currentOffsetY: currentOffsetY, offsetYToCompareTo: offsetYToCompareTo, withVisibleTitleWhenTransparent: false)
    }

    func changeHeaderDimViewAlphaWith(currentOffsetY offsetY: CGFloat) {
        guard let tableHeader = bookTable.tableHeaderView as? TableHeaderView else { return }
        
        let height = tableHeader.bounds.size.height + 10
        let maxOffset = tableViewInitialOffsetY + height
        
        if offsetY <= tableViewInitialOffsetY && tableHeader.dimView.alpha != 0 {
            tableHeader.dimView.alpha = 0
        } else if offsetY >= maxOffset && tableHeader.dimView.alpha != 1 {
            tableHeader.dimView.alpha = 1
        } else if offsetY > tableViewInitialOffsetY && offsetY < maxOffset {
            let alpha = (offsetY + abs(tableViewInitialOffsetY)) / height
            tableHeader.dimView.alpha = alpha
        }
    }
    
    func layoutTableHeader() {
        guard let tableHeader = bookTable.tableHeaderView else { return }
        Utils.layoutTableHeaderView(tableHeader, inTableView: bookTable)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension BaseViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let category = category else { return 0 }
        return category.subCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableViewCellWithCollection.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let category = category else { return UIView() }
        let subCategoryKind = category.subCategories[section].kind
        guard subCategoryKind != .seriesCategoryButton, subCategoryKind != .allCategoriesButton else { return UIView() }
        guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView else { return UIView() }
        let subCategory = category.subCategories[section]
        
        sectionHeader.configureFor(subCategory: subCategory, sectionNumber: section, category: category, withSeeAllButtonDidTapCallback: { [weak self] in
            guard let self = self else { return }
            if let categoryToShow = subCategory.categoryToShow {
                let controller = CategoryViewController(categoryModel: categoryToShow)
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                let subCategoryIndex = section
                if let books = self.booksDict[subCategoryIndex] {
                    let controller = AllTitlesViewController(subCategory: subCategory, books: books)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        })
        return sectionHeader
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        // If all categories have subCategories, this checking is not needed, just use calculateEstimatedHeightFor
        guard let category = category else { return 0 }
        if !category.subCategories.isEmpty {
            let subCategory = category.subCategories[section]
            return SectionHeaderView.calculateEstimatedHeightFor(subCategory: subCategory, superviewWidth: view.bounds.width)
        }
        return 0
    }
    
}

// MARK: - UIScrollViewDelegate
extension BaseViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        guard isInitialOffsetYSet else {
            tableViewInitialOffsetY = scrollView.contentOffset.y
            isInitialOffsetYSet = true
            return
        }
        // Toggle navbar from transparent to visible at calculated contentOffset
        adjustNavBarAppearanceTo(currentOffsetY: currentOffsetY)
    }
    
}

