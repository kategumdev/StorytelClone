//
//  HomeViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - Instance properties
    private let popupButton: PopupButton
    
    private lazy var indicesOfSubCategoriesForBooksWithOverview: [Int] = {
        guard let category = category else { return [Int]() }
        var indices = [Int]()
        for (index, subCategory) in category.subCategories.enumerated() {
            if subCategory.kind == .oneBookOverview {
                indices.append(index)
            }
        }
        return indices
    }()
    
    init(popupButton: some PopupButton = DefaultPopupButton(), categoryModel: Category? = nil, tableViewStyle: UITableView.Style = .grouped, networkManager: NetworkManager = AlamofireNetworkManager()) {
        self.popupButton = popupButton
        super.init(categoryModel: categoryModel, tableViewStyle: tableViewStyle, networkManager: networkManager)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard !didAppearFirstTime else {
            didAppearFirstTime = false
            return
        }
        // Update heart symbol (if needed) for sections created with .oneBookWithOverview subCategoryKind
        let sectionsToReload = IndexSet(indicesOfSubCategoriesForBooksWithOverview)
        bookTable.reloadSections(sectionsToReload, with: .none)
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
        case .horzCv: return cellWithHorizontalCv(in: tableView, for: indexPath)
        case .vertCv: return UITableViewCell()
        case .oneBookOverview: return bookWithOverviewCell(in: tableView, for: indexPath)
        case .poster: return posterCell(in: tableView, for: indexPath)
        case .horzCvLargeCovers: return cellWithLargeCoversHorizontalCv(in: tableView, for: indexPath)
        case .seriesCategoryButton: return wideButtonCell(in: tableView, for: indexPath)
        case .allCategoriesButton: return wideButtonCell(in: tableView, for: indexPath)
        case .searchVc: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let category = category else { return 0 }
        let subCategoryKind = category.subCategories[indexPath.section].kind
        
        switch subCategoryKind {
        case .horzCv: return TableViewCellWithCollection.rowHeight
        case .vertCv: return 0
        case .oneBookOverview:
            let subCategoryIndex = indexPath.section
            let book = booksDict[subCategoryIndex]?.first
            return BookWithOverviewTableViewCell.calculateHeightForRow(withBook: book)
            
        case .poster: return PosterTableViewCell.heightForRow
        case .horzCvLargeCovers: return TableViewCellWithHorzCvLargeRectangleCovers.rowHeight
        case .seriesCategoryButton: return WideButtonTableViewCell.rowHeight
        case .allCategoriesButton: return WideButtonTableViewCell.rowHeight
        case .searchVc: return 0
        }
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
        bookTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: popupButton.buttonHeight, right: 0)
    }

    private func posterCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PosterTableViewCell.identifier, for: indexPath) as? PosterTableViewCell else { return UITableViewCell()}
        let subCategoryIndex = indexPath.section
        if let book = booksDict[subCategoryIndex]?.first {
            cell.configureFor(book: book, withCallback: dimmedAnimationButtonDidTapCallback)
        }
         return cell
    }
    
    private func cellWithHorizontalCv(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }
        let subCategoryIndex = indexPath.section
        if let books = booksDict[subCategoryIndex] {
            cell.configureFor(books: books, callback: dimmedAnimationButtonDidTapCallback)
        }
        return cell
    }
    
    private func cellWithLargeCoversHorizontalCv(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithHorzCvLargeRectangleCovers.identifier, for: indexPath) as? TableViewCellWithHorzCvLargeRectangleCovers else { return UITableViewCell()}
        let subCategoryIndex = indexPath.section
        if let books = booksDict[subCategoryIndex] {
            cell.configureWith(books: books, callback: dimmedAnimationButtonDidTapCallback)
        }
        return cell
    }
    
    private func bookWithOverviewCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookWithOverviewTableViewCell.identifier, for: indexPath) as? BookWithOverviewTableViewCell else { return UITableViewCell() }
        let subCategoryIndex = indexPath.section
        if let book = booksDict[subCategoryIndex]?.first {
            cell.configureFor(book: book, withCallbackForDimmedAnimationButton: dimmedAnimationButtonDidTapCallback, withCallbackForSaveButton: popupButton.reconfigureAndAnimateSelf)
        }
         return cell
    }
    
    private func wideButtonCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WideButtonTableViewCell.identifier, for: indexPath) as? WideButtonTableViewCell else { return UITableViewCell()}
        if let category = category {
            cell.configureFor(subCategoryKind: category.subCategories[indexPath.section].kind, withCallback: dimmedAnimationButtonDidTapCallback)
        }
        return cell
    }

}
