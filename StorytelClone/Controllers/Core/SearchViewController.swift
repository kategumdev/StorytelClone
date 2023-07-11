//
//  SearchViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Instance properties
    private let model: Category
    private let categoriesForButtons: [Category]
    
    private let networkManager: any NetworkManager
    private var previousQueryString = ""
    private var firstTimeUpdateResults = true
    
    private let numberOfButtonsSection0 = 6
    
    private lazy var numberOfButtonsSection1: Int = {
        return categoriesForButtons.count - numberOfButtonsSection0
    }()
    
    private var initialTableOffsetY: CGFloat = 0
    private var didLayoutSubviewsFirstTime = true
            
    let categoriesTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = UIColor.customBackgroundColor
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
        table.allowsSelection = false
        
        table.register(
            CategoriesTableViewCell.self,
            forCellReuseIdentifier: CategoriesTableViewCell.identifier)
        table.register(
            SectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        
        // Enable correct usage of heightForFooterInSection method
        table.sectionFooterHeight = 0
        
        table.tableFooterView = UIView()
        table.tableFooterView?.frame.size.height = SectionHeaderView.topPadding
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.searchBarStyle = .minimal
        controller.hidesNavigationBarDuringPresentation = false
        controller.showsSearchResultsController = true
        
        // Set color of the prompt
        controller.searchBar.tintColor = UIColor.customTintColor
                
        // Configure placeholder string
        if let textField = controller.searchBar.value(forKey: "searchField") as? UITextField {
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.createScaledFontWith(textStyle: .callout, weight: .regular),
                .foregroundColor: UIColor.gray
            ]
            let attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: placeholderAttributes)
            textField.attributedPlaceholder = attributedPlaceholder
        }
        
        // Configure cancel button
        let cancelButtonAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.createScaledFontWith(textStyle: .callout, weight: .regular),
            .foregroundColor: UIColor.customTintColor
        ]
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        .setTitleTextAttributes(cancelButtonAttributes, for: .normal)

        return controller
    }()
    
    // MARK: - Initializers
    init(categoryModel: Category, categoriesForButtons: [Category],
         networkManager: some NetworkManager = AlamofireNetworkManager()) {
        self.categoriesForButtons = categoriesForButtons
        self.model = categoryModel
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.makeAppearance(transparent: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = view.bounds
        frame.size.height = view.bounds.height - UITabBar.tabBarHeight
        categoriesTable.frame = frame
        
        if didLayoutSubviewsFirstTime {
            didLayoutSubviewsFirstTime = false
            initialTableOffsetY = categoriesTable.contentOffset.y
        } else {
            // After searchResultsController was presented, actual initial contentOffset.y sets to 0
            initialTableOffsetY = 0
        }
        
    }
}

// MARK: - UISearchBarDelegate, UISearchControllerDelegate
extension SearchViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handleTextChangedTo(searchText: searchText)
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        let navBar = navigationController?.navigationBar
        
        /* Avoid showing content of SearchViewController behind navbar when
         SearchResultsController is being presented */
        navBar?.isTranslucent = false
        
        let currentTableOffsetY = categoriesTable.contentOffset.y
        if currentTableOffsetY != initialTableOffsetY {
            /* While table view bounces and user taps into the search bar,
             currentOffset.y that is checked here, can differ a bit from the inital value.
             This check avoids changing navbar appearance in such cases */
            let difference = (currentTableOffsetY - initialTableOffsetY)
            guard difference > 5 else { return }
            navBar?.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        // Revert back to the initial appearance of the navigation bar
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.scrollEdgeAppearance = nil
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        networkManager.cancelRequests()
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController
        else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            resultsController.revertToInitialAppearance()
            self?.handleTextChangedTo(searchText: "")
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoriesTableViewCell.identifier,
            for: indexPath) as? CategoriesTableViewCell
        else { return UITableViewCell() }
        
        var categoriesForButtons = [Category]()
        if indexPath.section == 0 {
            categoriesForButtons += self.categoriesForButtons.prefix(upTo: numberOfButtonsSection0)
        } else {
            categoriesForButtons += self.categoriesForButtons.dropFirst(numberOfButtonsSection0)
        }
        
        let callback: DimmedAnimationButtonDidTapCallback = { [weak self] controller in
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        cell.configureWith(categoriesForButtons: categoriesForButtons, andCallback: callback)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        getHeightForRowIn(section: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        getViewForHeaderIn(section: section, ofTableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = section == 0 ? 23 : UITableView.automaticDimension
        return height
    }
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForHeaderInSection section: Int
    ) -> CGFloat {
        getEstimatedHeightForHeaderIn(section: section)
    }
}

// MARK: - BottomSheetViewControllerDelegate
extension SearchViewController: BottomSheetViewControllerDelegate {
    func bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook book: Book) {
        #warning("Configure book model object in data model")
    }
}

// MARK: - Helper methods
extension SearchViewController {
    private func configureSelf() {
        setupUI()
        configureSearchResultsController()
        setupNotificationObserver()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.customBackgroundColor
        
        view.addSubview(categoriesTable)
        categoriesTable.delegate = self
        categoriesTable.dataSource = self
        
        configureSearchController()
        configureNavBar()
        extendedLayoutIncludesOpaqueBars = true
    }
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.delegate = self
    }
    
    private func configureNavBar() {
        navigationItem.title = "Explore"
        navigationController?.navigationBar.tintColor = .label
        navigationItem.backButtonTitle = ""
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.makeAppearance(transparent: false)
        navigationController?.navigationBar.barTintColor = UIColor.customTintColor
    }
    
    private func configureSearchResultsController() {
        guard let searchResultsController = searchController.searchResultsController as? SearchResultsViewController
        else { return }
        
        searchResultsController.didSelectRowCallback = { [weak self] selectedSearchResultTitle in
            if let book = selectedSearchResultTitle as? Book {
                let vc = BookViewController(book: book)
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = AllTitlesViewController(
                    subCategory: SubCategory.generalForAllTitlesVC,
                    titleModel: selectedSearchResultTitle)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }

        searchResultsController.ellipsisButtonDidTapCallback = { [weak self] book in
            let bookDetailsBottomSheetController = BottomSheetViewController(book: book, kind: .bookDetails)
            bookDetailsBottomSheetController.delegate = self
            bookDetailsBottomSheetController.modalPresentationStyle = .overFullScreen
            self?.present(bookDetailsBottomSheetController, animated: false)
        }
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardDismissNotification(_:)),
            name: scopeTableViewDidRequestKeyboardDismiss, object: nil)
    }
    
    @objc func handleKeyboardDismissNotification(_ notification: Notification) {
        if searchController.searchBar.isFirstResponder {
            searchController.searchBar.endEditing(true)
        }
    }
    
    private func handleTextChangedTo(searchText: String) {
        networkManager.cancelRequests()
        let query = searchText.trimmingCharacters(in: .whitespaces)
        
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController
        else { return }

        if query.isEmpty {
            // Setting modelForSearchQuery to nil ensures that table view will be configured with initial model
            resultsController.modelForSearchQuery = nil
            return
        }

        networkManager.fetchBooks(
            withQuery: query,
            bookKindsToFetch: .ebooksAndAudiobooks
        ) { [weak resultsController] result in
            resultsController?.handleSearchResult(result)
        }
    }
    
    private func getHeightForRowIn(section: Int) -> CGFloat {
        let numberOfRowsInCell: CGFloat
        
        if section == 0 {
            numberOfRowsInCell = ceil(CGFloat(numberOfButtonsSection0) / 2.0)
        } else if section == 1 {
            numberOfRowsInCell = ceil(CGFloat(numberOfButtonsSection1) / 2.0)
        } else {
            numberOfRowsInCell = 0
            print("Cell in section \(section) is not handled")
        }

        let height = CategoriesTableViewCell.calculateCellHeightFor(numberOfRows: numberOfRowsInCell)
        return height
    }
    
    private func getViewForHeaderIn(section: Int, ofTableView tableView: UITableView) -> UIView? {
        if section == 0 { return UIView() }
                
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView
        else { return UIView() }
        
        let subCategory = model.subCategories[section]
        header.configureFor(subCategory: subCategory)
        return header
    }
    
    private func getEstimatedHeightForHeaderIn(section: Int) -> CGFloat {
        if section == 0 { return SectionHeaderView.topPadding }
        
        let subCategory = model.subCategories[section]
        let calculatedHeight = SectionHeaderView.calculateEstimatedHeightFor(
            subCategory: subCategory,
            superviewWidth: view.bounds.width)
        return calculatedHeight
    }
    
}

