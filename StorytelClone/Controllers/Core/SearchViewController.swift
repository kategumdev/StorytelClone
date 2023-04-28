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
    
//    private var previousSize: UIContentSizeCategory?
        
    let categoriesTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = Utils.customBackgroundColor
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
        table.allowsSelection = false
        
        table.register(CategoriesTableViewCellWithCollection.self, forCellReuseIdentifier: CategoriesTableViewCellWithCollection.identifier)
        table.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        
        // Enbale correct usage of heightForFooterInSection
        table.sectionFooterHeight = 0
        
        table.tableFooterView = UIView()
        table.tableFooterView?.frame.size.height = Constants.sectionHeaderViewTopPadding

        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.searchBarStyle = .minimal
        controller.hidesNavigationBarDuringPresentation = false
//        controller.obscuresBackgroundDuringPresentation = false
//        controller.automaticallyShowsSearchResultsController
        controller.showsSearchResultsController = true
        // To set color of the prompt
        controller.searchBar.tintColor = Utils.tintColor
                
        // Configure placeholder string
        if let textField = controller.searchBar.value(forKey: "searchField") as? UITextField {
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.preferredCustomFontWith(weight: .regular, size: 16), .foregroundColor: UIColor.gray
            ]
            
            let attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
            textField.attributedPlaceholder = attributedPlaceholder
        }
        
        // Configure cancel button
        let cancelButtonAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredCustomFontWith(weight: .regular, size: 16),
            .foregroundColor: Utils.tintColor
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
        view.backgroundColor = Utils.customBackgroundColor
        view.addSubview(categoriesTable)
        categoriesTable.delegate = self
        categoriesTable.dataSource = self
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
//        searchController.definesPresentationContext = true

        configureNavBar()
        
        createAndPassItemSelectedCallback()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDismissNotification(_:)), name: tableDidRequestKeyboardDismiss, object: nil)
        
        extendedLayoutIncludesOpaqueBars = true
        
//        previousSize = traitCollection.preferredContentSizeCategory
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.makeNavbarAppearance(transparent: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = view.bounds
        frame.size.height = view.bounds.height - Utils.tabBarHeight
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
    private func createAndPassItemSelectedCallback() {

        
        guard let searchResultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        let callbackClosure: (Title) -> () = { [weak self] selectedSearchResultTitle in
//            guard let self = self else { return }
            if let book = selectedSearchResultTitle as? Book {
                print("SearchViewController handles selected book \(book.title)")
                let controller = BookViewController(book: book)
                self?.navigationController?.pushViewController(controller, animated: true)
            } else {
                let controller = AllTitlesViewController(tableSection: TableSection.generalForAllTitlesVC, titleModel: selectedSearchResultTitle)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        searchResultsController.tableViewInSearchResultsCollectionViewCellDidSelectRowCallback = callbackClosure

        searchResultsController.ellipsisButtonInSearchResultsBookTableViewCellDidTapCallback = { [weak self] book in
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
        navigationController?.navigationBar.barTintColor = Utils.tintColor
    }
    
    private func getModelFor(buttonCategory: ButtonCategory) -> Category {
        return ButtonCategory.createModelFor(categoryButton: buttonCategory)
    }
    
    private func fetchTitlesFor(query: String) -> [ButtonKind : [Title]] {
        // It's HARDCODED FOR NOW. Use query for real fetching from web service/server
        var newModel = [ButtonKind : [Title]]()
        let buttonKinds = ButtonKind.allCases
        for buttonKind in buttonKinds {
            switch buttonKind {
            case .top:
                newModel[buttonKind] = [Book.book5, Author.neilGaiman, Series.series1, Author.tolkien,
                                        Author.author9, Book.book1, Book.book10, Author.author10, Author.author6]
            case .books:
                newModel[buttonKind] = [Book.senorDeLosAnillos2, Book.book3, Book.book4, Book.book5, Book.book6,
                                        Book.book23, Book.book22, Book.book7, Book.book8, Book.book9, Book.book21, Book.book8, Book.book13, Book.book20]
            case .authors:
                newModel[buttonKind] = [Author.neilGaiman, Author.tolkien, Author.author1, Author.author2, Author.author3, Author.author4, Author.author5, Author.author6, Author.author7, Author.author8, Author.author9, Author.author10]
            case .narrators: newModel[buttonKind] = [Narrator.narrator10, Narrator.narrator3, Narrator.narrator5]
            case .series: newModel[buttonKind] = [Series.series3, Series.series2, Series.series1]
            case .tags: newModel[buttonKind] = [Tag.tag10, Tag.tag9, Tag.tag10]
            }
        }
        return newModel
    }
    
}

// MARK: - UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {

    // Called when searchResultsController becomes visible and unvisible (after tapping Cancel)
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults")
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        let queryString = query.trimmingCharacters(in: .whitespaces)
        if !queryString.isEmpty {
            // Fetch model objects for search query and create models for all buttonKinds. HARDCODED FOR NOW
            print("setting newModel")
            let newModel = fetchTitlesFor(query: query)
            resultsController.modelForSearchQuery = newModel
            resultsController.setInitialOffsetsOfTablesInCells()
            resultsController.collectionView.reloadData()
        } else {
//            print("revert to initial model")
            if resultsController.modelForSearchQuery != nil {
                print("revert to initial model")
                resultsController.modelForSearchQuery = nil
                resultsController.setInitialOffsetsOfTablesInCells()
                resultsController.collectionView.reloadData()
            }
        }

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Make some changes when the search bar begins editing
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        print("willPresentSearchController")
                
        // To avoid showing content of SearchViewController behind navbar when SearchResultsController is being presented
        navigationController?.navigationBar.isTranslucent = false
        
        // Change navbar appearance if currentOffset.y != initialTableOffsetY
        let currentTableOffsetY = categoriesTable.contentOffset.y
        if currentTableOffsetY != initialTableOffsetY {
            // While table view bounces and user taps into the search bar, currentOffset.y checked here can differ a bit from inital value. This check difference > 5 avoids changing navbar appearance in such cases
            let difference = (currentTableOffsetY - initialTableOffsetY)
            guard difference > 5 else { return }
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        print("willDismissSearchController")
        // Revert back to the original appearance of the navigation bar
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.scrollEdgeAppearance = nil
        
    }
    
//    func didDismissSearchController(_ searchController: UISearchController) {
////        print("didDismissSearchController")
//        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
//    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            resultsController.revertToInitialAppearance()
        }
        #warning("This revert must be done only after cancel button is tapped, but now it also executes if app goes to background and then back to foreground")
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
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCellWithCollection.identifier, for: indexPath) as? CategoriesTableViewCellWithCollection else { return UITableViewCell() }
//
//        // Respond to button tap in CategoryCollectionViewCell
//        cell.dimmedAnimationButtonDidTapCallback = { [weak self] buttonCategory in
//            guard let self = self, let category = buttonCategory as? ButtonCategory else { return }
//            let categoryModel = self.getModelFor(buttonCategory: category)
//            let controller = CategoryViewController(categoryModel: categoryModel)
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//
//        var buttonCategories = [ButtonCategory]()
//        if indexPath.section == 0 {
//            buttonCategories += self.categoryButtons.prefix(upTo: 6)
//        } else {
//            buttonCategories += self.categoryButtons.dropFirst(6)
//        }
//        cell.categoryButtons = buttonCategories
//
//        return cell
//    }
    
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
        if section == 0 {
            return UIView()
        } else {
            guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView else { return UIView() }
//            let currentSection = model.tableSections[section]
//            sectionHeader.configureFor(section: currentSection)
            return sectionHeader
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 23
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return Constants.sectionHeaderViewTopPadding
        } else {
            let currentSection = model.tableSections[section]
            let calculatedHeight = SectionHeaderView.calculateEstimatedHeightFor(tableSection: currentSection, superviewWidth: view.bounds.width)
            return calculatedHeight
        }
    }
    
}

//extension SearchViewController: SearchResultsCollectionViewCellDelegate {
//    func searchResultsCollectionViewCellDidRequestKeyboardDismiss(_ searchResultsCollectionViewCell: SearchResultsCollectionViewCell) {
//        if searchController.searchBar.isFirstResponder {
//            searchController.searchBar.endEditing(true)
//        }
//    }
//
//    func searchResultsCollectionViewCell(_ searchResultsCollectionViewCell: SearchResultsCollectionViewCell, didSelectItem: Book) {
//        print("SearchViewController knows that item was selected")
//    }
//}

extension SearchViewController: BottomSheetViewControllerDelegate {
    func bookDetailsBottomSheetViewControllerDidSelectSaveBookCell(withBook book: Book) {
        // Nothing needs to be done
        #warning("Configure book model object in data model")
    }
}
