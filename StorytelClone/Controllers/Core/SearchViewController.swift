//
//  SearchViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let model: Category
    private let categoriesForButtons: [Category]
    
    private let networkManager = NetworkManager()
    private var previousQueryString = ""
    private var firstTimeUpdateResults = true
    
    private let numberOfButtonsSection0 = 6
    private let numberOfButtonsSection1 = 19
    
    private var initialTableOffsetY: CGFloat = 0
    private var firstTime = true
            
    let categoriesTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = UIColor.customBackgroundColor
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
        table.allowsSelection = false
        
        table.register(CategoriesTableViewCellWithCollection.self, forCellReuseIdentifier: CategoriesTableViewCellWithCollection.identifier)
        table.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        
        // Enbale correct usage of heightForFooterInSection
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
                .font: UIFont.createScaledFontWith(textStyle: .callout, weight: .regular), .foregroundColor: UIColor.gray
            ]
            let attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
            textField.attributedPlaceholder = attributedPlaceholder
        }
        
        // Configure cancel button
        let cancelButtonAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.createScaledFontWith(textStyle: .callout, weight: .regular),
            .foregroundColor: UIColor.customTintColor
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)

        return controller
    }()
    
    // MARK: - Initializers
    init(categoryModel: Category, categoriesForButtons: [Category]) {
        self.categoriesForButtons = categoriesForButtons
        self.model = categoryModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customBackgroundColor
        view.addSubview(categoriesTable)
        categoriesTable.delegate = self
        categoriesTable.dataSource = self
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.delegate = self

        configureNavBar()
        configureSearchResultsController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDismissNotification(_:)), name: scopeTableViewDidRequestKeyboardDismiss, object: nil)
        
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.makeNavbarAppearance(transparent: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = view.bounds
        frame.size.height = view.bounds.height - UITabBar.tabBarHeight
        categoriesTable.frame = frame
        
        if firstTime {
            initialTableOffsetY = categoriesTable.contentOffset.y
            firstTime = false
        } else {
            // After searchResultsController was presented, actual initial contentOffset.y changes to 0
            initialTableOffsetY = 0
        }
    }
    
    //MARK: - Helper methods
    private func configureSearchResultsController() {
        guard let searchResultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        searchResultsController.didSelectRowCallback = { [weak self] selectedSearchResultTitle in
            if let book = selectedSearchResultTitle as? Book {
                print("SearchViewController handles selected book \(book.title)")
                let controller = BookViewController(book: book)
                self?.navigationController?.pushViewController(controller, animated: true)
            } else {
                print("SearchViewController handles \(selectedSearchResultTitle.titleKind)")
                let controller = AllTitlesViewController(subCategory: SubCategory.generalForAllTitlesVC, titleModel: selectedSearchResultTitle)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }

        searchResultsController.ellipsisButtonDidTapCallback = { [weak self] book in
            let bookDetailsBottomSheetController = BottomSheetViewController(book: book, kind: .bookDetails)
            bookDetailsBottomSheetController.delegate = self
            bookDetailsBottomSheetController.modalPresentationStyle = .overFullScreen
            self?.present(bookDetailsBottomSheetController, animated: false)
        }
    }
    
    @objc func handleKeyboardDismissNotification(_ notification: Notification) {
        if searchController.searchBar.isFirstResponder {
            searchController.searchBar.endEditing(true)
        }
    }
    
    private func configureNavBar() {
        navigationItem.title = "Explore"
        navigationController?.navigationBar.tintColor = .label
        navigationItem.backButtonTitle = ""
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.makeNavbarAppearance(transparent: false)
        navigationController?.navigationBar.barTintColor = UIColor.customTintColor
    }
    
}

// MARK: - UISearchBarDelegate, UISearchControllerDelegate
extension SearchViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\n\ntextDidChange")
        networkManager.cancelTasks()
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }

        let queryString = query.trimmingCharacters(in: .whitespaces)
        if queryString.isEmpty {
            // Setting modelForSearchQuery to nil ensures that table view will be configured with initial model
            resultsController.modelForSearchQuery = nil
            return
        }

#warning("make sure weak resultsController is ok here")
        networkManager.fetchBooks(withQuery: query, bookKindsToFetch: .ebooksAndAudiobooks) { [weak resultsController] result in
            print("networkManager fetches for \(queryString)")
            resultsController?.handleSearchResult(result)
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        // Avoid showing content of SearchViewController behind navbar when SearchResultsController is being presented
        navigationController?.navigationBar.isTranslucent = false
        
        let currentTableOffsetY = categoriesTable.contentOffset.y
        if currentTableOffsetY != initialTableOffsetY {
            // While table view bounces and user taps into the search bar, currentOffset.y checked here can differ a bit from inital value. This check avoids changing navbar appearance in such cases
            let difference = (currentTableOffsetY - initialTableOffsetY)
            guard difference > 5 else { return }
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        // Revert back to the original appearance of the navigation bar
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.scrollEdgeAppearance = nil
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        networkManager.cancelTasks()
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            resultsController.revertToInitialAppearance()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCellWithCollection.identifier, for: indexPath) as? CategoriesTableViewCellWithCollection else { return UITableViewCell() }
        
        var categoriesForButtons = [Category]()
        if indexPath.section == 0 {
            categoriesForButtons += self.categoriesForButtons.prefix(upTo: 6)
        } else {
            categoriesForButtons += self.categoriesForButtons.dropFirst(6)
        }
        
        let callback: DimmedAnimationButtonDidTapCallback = { [weak self] controller in
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        cell.configureWith(categoriesForButtons: categoriesForButtons, andCallback: callback)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let numberOfRowsInCell: CGFloat
        if indexPath.section == 0 {
            numberOfRowsInCell = ceil(CGFloat(numberOfButtonsSection0) / 2.0)
        } else if indexPath.section == 1 {
            numberOfRowsInCell = ceil(CGFloat(numberOfButtonsSection1) / 2.0)
        } else {
            numberOfRowsInCell = 0
            print("Cell in section \(indexPath.section) is not handled")
        }

        let height = CategoriesTableViewCellWithCollection.calculateCellHeightFor(numberOfRows: numberOfRowsInCell)
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return UIView() }
                
        guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView else { return UIView() }
        let subCategory = model.subCategories[section]
        sectionHeader.configureFor(subCategory: subCategory)
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = section == 0 ? 23 : UITableView.automaticDimension
        return height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return SectionHeaderView.topPadding }
        
        let subCategory = model.subCategories[section]
        let calculatedHeight = SectionHeaderView.calculateEstimatedHeightFor(subCategory: subCategory, superviewWidth: view.bounds.width)
        return calculatedHeight
    }
    
}

extension SearchViewController: BottomSheetViewControllerDelegate {
    func bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook book: Book) {
        // Nothing needs to be done
        #warning("Configure book model object in data model")
    }
}

