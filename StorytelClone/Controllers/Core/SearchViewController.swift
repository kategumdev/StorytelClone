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
//        controller.searchBar.placeholder = "Search"
        controller.searchBar.searchBarStyle = .minimal
        controller.hidesNavigationBarDuringPresentation = false
        // Show results controller when user taps into the search bar
        controller.showsSearchResultsController = true
        
//        controller.searchBar.scopeButtonTitles = ["Top", "Books", "Authors", "Narrators", "Series", "Tags"]
//        controller.scopeBarActivation = .onSearchActivation

        
        // Configure placeholder string
        if let textField = controller.searchBar.value(forKey: "searchField") as? UITextField {

            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 17)
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
//        searchController.searchBar.delegate = self

        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("viewDidLayoutSubviews")
        categoriesTable.frame = view.bounds
    }
    
    //MARK: - Helper methods
    private func configureNavBar() {
        navigationItem.title = "Explore"
        navigationController?.navigationBar.tintColor = .label
        navigationItem.backButtonTitle = ""
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
    }
    
    private func getModelFor(buttonCategory: ButtonCategory) -> Category {
        return ButtonCategory.createModelFor(categoryButton: buttonCategory)
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
     
    func updateSearchResults(for searchController: UISearchController) {
        
        print("updateSearchResults triggered")
        let searchBar = searchController.searchBar
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        
//        guard let query = searchBar.text,
//              !query.trimmingCharacters(in: .whitespaces).isEmpty,
//              query.trimmingCharacters(in: .whitespaces).count >= 3,
//              let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
//        resultsController.delegate = self
        
//        APICaller.shared.search(with: query) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let titles):
//                    resultsController.titles = titles
//                    resultsController.searchResultsCollectionView.reloadData()
//                case .failure(let error):
//                    print(error.localizedDescription )
//                }
//            }
//        }
    }
    
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        print("New scope index is now \(selectedScope)")
//    }
    
//    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
//
//        DispatchQueue.main.async { [weak self] in
//            let vc = TitlePreviewViewController()
//            vc.configure(with: viewModel)
//            self?.navigationController?.pushViewController(vc, animated: true)
//        }
//
//    }
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


