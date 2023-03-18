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
        
        // Avoid gap at the very bottom of the table view
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        table.contentInset = inset
        
        table.register(CategoriesTableViewCellWithCollection.self, forCellReuseIdentifier: CategoriesTableViewCellWithCollection.identifier)
        table.register(NoButtonSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: NoButtonSectionHeaderView.identifier)
        
        // Enbale correct usage of heightForFooterInSection
        table.sectionFooterHeight = 0
        
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.searchBarStyle = .minimal
        controller.hidesNavigationBarDuringPresentation = false
//        controller.obscuresBackgroundDuringPresentation = false
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
    
    init(categoryModel: Category, categoryButtons: [ButtonCategory]) {
        self.categoryButtons = categoryButtons
        self.model = categoryModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
//        definesPresentationContext = true

        configureNavBar()
        
        createAndPassItemSelectedCallback()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDismissNotification(_:)), name: tableDidRequestKeyboardDismiss, object: nil)
        
//        previousSize = traitCollection.preferredContentSizeCategory
        
//        NotificationCenter.default.addObserver(self, selector: #selector(contentSizeCategoryDidChange(_:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoriesTable.frame = view.bounds
        
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
        let callbackClosure: ItemSelectedCallback = { [weak self] item in
            
            guard let item = item as? Book else { return }
            print("SearchViewController handles item selected \(item.title)")
        }
        
        guard let searchResultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        searchResultsController.itemSelectedCallback = callbackClosure
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
        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
        navigationController?.navigationBar.barTintColor = Utils.tintColor
    }
    
    private func getModelFor(buttonCategory: ButtonCategory) -> Category {
        return ButtonCategory.createModelFor(categoryButton: buttonCategory)
    }
    
}

// MARK: - UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    // Called when searchResultsController becomes visible and unvisible (after tapping Cancel)
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        if searchBar.isFirstResponder == false {
            // When cancel button was tapped
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            // Make some changes when the search bar begins editing
        }

    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
//        print("willPresentSearchController")
                
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
//        print("willDismissSearchController")
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
        
        // Respond to button tap in CategoryCollectionViewCell
        cell.callbackClosure = { [weak self] buttonCategory in
            guard let self = self, let category = buttonCategory as? ButtonCategory else { return }
            
            let categoryModel = self.getModelFor(buttonCategory: category)
            let controller = CategoryViewController(categoryModel: categoryModel)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        var buttonCategories = [ButtonCategory]()
        if indexPath.section == 0 {
            buttonCategories += self.categoryButtons.prefix(upTo: 6)
        } else {
            buttonCategories += self.categoryButtons.dropFirst(6)
        }
        cell.categoryButtons = buttonCategories
        
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
        if section == 0 {
            return UIView()
        } else {
            guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoButtonSectionHeaderView.identifier) as? NoButtonSectionHeaderView else { return UIView() }
            
            sectionHeader.configureFor(section: model.tableSections[section])
            return sectionHeader
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 23
//            return Constants.generalTopPaddingSectionHeader
        } else {
            // Get height for headers with no button
            let calculatedHeight = NoButtonSectionHeaderView.calculateHeaderHeightFor(section: model.tableSections[section])
            
            return calculatedHeight
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return Constants.generalTopPaddingSectionHeader
        } else {
            // Get height for headers with no button
            let calculatedHeight = NoButtonSectionHeaderView.calculateHeaderHeightFor(section: model.tableSections[section])

            return calculatedHeight
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == model.tableSections.count - 1 {
            return Constants.generalTopPaddingSectionHeader
        } else {
            return 0
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

