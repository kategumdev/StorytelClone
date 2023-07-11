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
    
    // MARK: - Initializers
    init(popupButton: some PopupButton = DefaultPopupButton(),
         categoryModel: Category? = nil,
         tableViewStyle: UITableView.Style = .grouped,
         networkManager: some NetworkManager = AlamofireNetworkManager(),
         imageDownloader: some ImageDownloader = DefaultSDWebImageDownloader()) {
        self.popupButton = popupButton
        super.init(categoryModel: categoryModel, tableViewStyle: tableViewStyle,
                   networkManager: networkManager, imageDownloader: imageDownloader)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        
        // Update heart symbol (if needed) for sections with .oneBookWithOverview subCategoryKind
        let sectionsToReload = IndexSet(indicesOfSubCategoriesForBooksWithOverview)
        bookTable.reloadSections(sectionsToReload, with: .none)
    }
    
    // MARK: - Superclass overrides
    override func configureNavBar() {
        super.configureNavBar()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let image = UIImage(systemName: "bell", withConfiguration: symbolConfig)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .done,
            target: self,
            action: nil)
        
        title = "Home"
        extendedLayoutIncludesOpaqueBars = true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController {
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        dequeueCustomCell(in: tableView, for: indexPath)
    }
    
    override func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        getHeightForRow(with: indexPath)
    }
    
    override func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        getHeightForHeaderIn(section: section)
    }
}

// MARK: - Helper methods
extension HomeViewController {
    
    private func setupUI() {
        configureTable()
        view.addSubview(popupButton)
    }
    
    private func configureTable() {
        bookTable.register(
            WideButtonTableViewCell.self,
            forCellReuseIdentifier: WideButtonTableViewCell.identifier)
        
        bookTable.register(
            PosterTableViewCell.self,
            forCellReuseIdentifier: PosterTableViewCell.identifier)
        
        bookTable.register(
            LargeRectCoversTableViewCell.self,
            forCellReuseIdentifier: LargeRectCoversTableViewCell.identifier)
        
        bookTable.register(
            OneBookOverviewTableViewCell.self,
            forCellReuseIdentifier: OneBookOverviewTableViewCell.identifier)
        
        bookTable.contentInset.bottom = popupButton.buttonHeight
    }
    
    private func getHeightForRow(with indexPath: IndexPath) -> CGFloat {
        guard let category = category else { return 0 }
        let subCategoryKind = category.subCategories[indexPath.section].kind
        
        switch subCategoryKind {
        case .horzCv: return TableViewCellWithCollection.rowHeight
        case .vertCv: return 0
        case .oneBookOverview:
            let subCategoryIndex = indexPath.section
            let book = booksDict[subCategoryIndex]?.first
            return OneBookOverviewTableViewCell.calculateHeightForRow(withBook: book)
        case .poster: return PosterTableViewCell.heightForRow
        case .largeRectCoversHorzCv: return LargeRectCoversTableViewCell.rowHeight
        case .seriesCategoryButton: return WideButtonTableViewCell.rowHeight
        case .allCategoriesButton: return WideButtonTableViewCell.rowHeight
        case .searchVc: return 0
        }
    }
    
    private func getHeightForHeaderIn(section: Int) -> CGFloat {
        guard let category = category else { return 0 }
        let subCategoryKind = category.subCategories[section].kind
        
        if subCategoryKind == .seriesCategoryButton || subCategoryKind == .allCategoriesButton {
            return SectionHeaderView.topPadding
        } else {
            return UITableView.automaticDimension
        }
    }
    
    private func dequeueCustomCell(
        in tableView: UITableView,
        for indexPath: IndexPath
    ) -> UITableViewCell {
        guard let category = category else { return UITableViewCell() }
        let subCategoryKind = category.subCategories[indexPath.section].kind
        
        switch subCategoryKind {
        case .horzCv: return cellWithHorzCv(in: tableView, for: indexPath)
        case .vertCv, .searchVc: return UITableViewCell()
        case .oneBookOverview:
            return cellWithOneBookOverview(in: tableView, for: indexPath)
        case .poster: return cellWithPoster(in: tableView, for: indexPath)
        case .largeRectCoversHorzCv:
            return cellWithLargeCoversHorzCv(in: tableView, for: indexPath)
        case .seriesCategoryButton, .allCategoriesButton:
            return cellWithWideButton(in: tableView, for: indexPath)
        }
    }
    
    private func cellWithPoster(
        in tableView: UITableView,
        for indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PosterTableViewCell.identifier,
            for: indexPath) as? PosterTableViewCell
        else {
            return UITableViewCell()
        }
        
        let subCategoryIndex = indexPath.section
        if let book = booksDict[subCategoryIndex]?.first {
            cell.configureFor(book: book, withCallback: dimmedAnimationButtonDidTapCallback)
        }
        
        return cell
    }
    
    private func cellWithHorzCv(
        in tableView: UITableView,
        for indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TableViewCellWithCollection.identifier,
            for: indexPath) as? TableViewCellWithCollection
        else {
            return UITableViewCell()
        }
        
        let subCategoryIndex = indexPath.section
        if let books = booksDict[subCategoryIndex] {
            cell.configureFor(books: books, callback: dimmedAnimationButtonDidTapCallback)
        }
        
        return cell
    }
    
    private func cellWithLargeCoversHorzCv(
        in tableView: UITableView,
        for indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LargeRectCoversTableViewCell.identifier,
            for: indexPath) as? LargeRectCoversTableViewCell
        else {
            return UITableViewCell()
        }
        
        let subCategoryIndex = indexPath.section
        if let books = booksDict[subCategoryIndex] {
            cell.configureWith(books: books, callback: dimmedAnimationButtonDidTapCallback)
        }
        return cell
    }
    
    private func cellWithOneBookOverview(
        in tableView: UITableView,
        for indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: OneBookOverviewTableViewCell.identifier,
            for: indexPath) as? OneBookOverviewTableViewCell
        else {
            return UITableViewCell()
        }
        
        let subCategoryIndex = indexPath.section
        if let book = booksDict[subCategoryIndex]?.first {
            cell.configureFor(
                book: book,
                dimmedAnimationButtonCallback: dimmedAnimationButtonDidTapCallback,
                callbackForSaveButton: popupButton.reconfigureAndAnimateSelf)
        }
        
        return cell
    }
    
    private func cellWithWideButton(
        in tableView: UITableView,
        for indexPath: IndexPath
    ) -> UITableViewCell {
        guard let category = category,
              let cell = tableView.dequeueReusableCell(
                withIdentifier: WideButtonTableViewCell.identifier,
                for: indexPath) as? WideButtonTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.configureFor(
            subCategoryKind: category.subCategories[indexPath.section].kind,
            withCallback: dimmedAnimationButtonDidTapCallback)
        
        return cell
    }
}
