//
//  SearchViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let model: Category
    private let categoryButtons: [ButtonCategory]
    
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
    init(categoryModel: Category, categoryButtons: [ButtonCategory]) {
        self.categoryButtons = categoryButtons
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
        searchController.searchResultsUpdater = self
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
                let controller = AllTitlesViewController(tableSection: TableSection.generalForAllTitlesVC, titleModel: selectedSearchResultTitle)
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
    
    private func fetchTitlesFor(query: String) -> [ScopeButtonKind : [Title]] {
        // It's HARDCODED FOR NOW. Use query for real fetching from web service/server
        var newModel = [ScopeButtonKind : [Title]]()
        let buttonKinds = ScopeButtonsViewKind.forSearchResultsVc.buttonKinds
        for buttonKind in buttonKinds {
            if buttonKind == .top {
                newModel[buttonKind] = [Book.book5, Storyteller.neilGaiman, Series.series1, Storyteller.tolkien, Storyteller.author9, Book.book1, Book.book10, Storyteller.author10, Storyteller.author6]
            }
            
            if buttonKind == .books {
                newModel[buttonKind] = [Book.senorDeLosAnillos2, Book.book3, Book.book4, Book.book5, Book.book6, Book.book23, Book.book22, Book.book7, Book.book8, Book.book9, Book.book21, Book.book8, Book.book13, Book.book20]
            }
            
            if buttonKind == .authors {
                newModel[buttonKind] = [Storyteller.neilGaiman, Storyteller.tolkien, Storyteller.author1, Storyteller.author2, Storyteller.author3, Storyteller.author4, Storyteller.author5, Storyteller.author6, Storyteller.author7, Storyteller.author8, Storyteller.author9, Storyteller.author10]
            }
            
            if buttonKind == .narrators {
                newModel[buttonKind] = [Storyteller.narrator10, Storyteller.narrator3, Storyteller.narrator5]
            }
            
            if buttonKind == .series {
                newModel[buttonKind] = [Series.series3, Series.series2, Series.series1]
            }
            
            if buttonKind == .tags {
                newModel[buttonKind] = [Tag.tag10, Tag.tag9, Tag.tag10]
            }
 
        }
        return newModel
    }
    
}

// MARK: - UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults")
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        let queryString = query.trimmingCharacters(in: .whitespaces)
        if !queryString.isEmpty {
            // Fetch model objects for search query and create models for all buttonKinds. HARDCODED FOR NOW
            let newModel = fetchTitlesFor(query: query)
            resultsController.modelForSearchQuery = newModel
            resultsController.setInitialOffsetsOfTablesInCells()
            resultsController.collectionView.reloadData()
        } else {
            // Setting modelForSearchQuery to nil ensures that table view will be configured with initial model
            if resultsController.modelForSearchQuery != nil {
                resultsController.modelForSearchQuery = nil
                resultsController.setInitialOffsetsOfTablesInCells()
                resultsController.collectionView.reloadData()
            }
        }
        
        
        guard !queryString.isEmpty else { return }
        
        guard query.count >= 6 else { return }
        APICaller.shared.getBooks(with: queryString) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    print("COUNT: \(books.count)")
                    print("BOOKS: \(books)")
                    let bookTitles = books.map { $0.volumeInfo.title }
                    print("GOOGLE BOOKS titles: \(bookTitles)")
                    
                    let firstBook = books[0]
                    if firstBook.volumeInfo.imageLinks?[ImageLink.smallThumbnail.rawValue] != nil {
                        print("book \(firstBook.volumeInfo.title) has small thumbnail image")
                    }
//                    resultsController.titles = titles
//                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        print("searchBarTextDidEndEditing")
//    }
    
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
        
        var buttonCategories = [ButtonCategory]()
        if indexPath.section == 0 {
            buttonCategories += self.categoryButtons.prefix(upTo: 6)
        } else {
            buttonCategories += self.categoryButtons.dropFirst(6)
        }
        
        let callback: DimmedAnimationButtonDidTapCallback = { [weak self] controller in
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        cell.configureWith(categoryButtons: buttonCategories, andCallback: callback)
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
        let currentSection = model.tableSections[section]
        sectionHeader.configureFor(tableSection: currentSection)
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = section == 0 ? 23 : UITableView.automaticDimension
        return height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return SectionHeaderView.topPadding }
        
        let currentSection = model.tableSections[section]
        let calculatedHeight = SectionHeaderView.calculateEstimatedHeightFor(tableSection: currentSection, superviewWidth: view.bounds.width)
        return calculatedHeight
    }
    
}

extension SearchViewController: BottomSheetViewControllerDelegate {
    func bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook book: Book) {
        // Nothing needs to be done
        #warning("Configure book model object in data model")
    }
}
