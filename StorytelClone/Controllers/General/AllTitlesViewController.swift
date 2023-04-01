//
//  AllTitlesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 31/3/23.
//

import UIKit

class AllTitlesViewController: BaseTableViewController {

    let tableSection: TableSection
    let book: Book?
    let series: Series?
    
//    let books = Book.books
    
    init(tableSection: TableSection, book: Book?, categoryOfParentVC: Category, series: Series? = nil) {
        self.tableSection = tableSection
        self.book = book
        self.series = series
        super.init(categoryModel: categoryOfParentVC, tableViewStyle: .plain)
        #warning("This category is not needed in this vc, only needed for BaseTableViewController initializer")
    }
    
//    init(tableSection: TableSection, categoryOfParentVC: Category) {
//        self.tableSection = tableSection
//        super.init(categoryModel: categoryOfParentVC, tableViewStyle: .plain)
//        #warning("This category is not needed in this vc, only needed for BaseTableViewController initializer")
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = Utils.customBackgroundColor
//        title = tableSection.sectionTitle
//        navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
//        navigationController?.navigationBar.standardAppearance = Utils.transparentNavBarAppearance
        
//        extendedLayoutIncludesOpaqueBars = true
//        navigationItem.backButtonTitle = ""
        configureBookTable()
    }
    
    private func configureBookTable() {
        bookTable.register(AllTitlesSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: AllTitlesSectionHeaderView.identifier)
        
        guard let headerView = bookTable.tableHeaderView as? TableHeaderView else { return }
        
        if let sectionDescription = tableSection.sectionDescription {
            headerView.configureWith(title: tableSection.sectionTitle, sectionDescription: sectionDescription)
        } else if tableSection.forSimilarBooks, let book = book {
            headerView.configureWith(title: tableSection.sectionTitle, bookTitleForSimilar: book.title)
        } else if let series = series {
            headerView.configureWith(seriesTitle: series.title, numberOfFollowers: series.numberOfFollowers)
        } else {
            headerView.configureWith(title: tableSection.sectionTitle)
        }
        
//        if let sectionDescription = tableSection.sectionDescription {
//            headerView.configureWith(title: tableSection.sectionTitle, sectionDescription: sectionDescription)
//        } else if tableSection.forSimilarBooks, let book = book {
//            headerView.configureWith(title: tableSection.sectionTitle, bookTitleForSimilar: book.title)
//        } else {
//            headerView.configureWith(title: tableSection.sectionTitle)
//        }

        headerView.stackTopAnchorConstraint.constant = headerView.stackTopAnchorForCategoryOrSectionTitle
    }
    
    // MARK: - Superclass overrides
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSection.books.count
//        return books.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.contentView.backgroundColor = .purple
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: AllTitlesSectionHeaderView.identifier) as? AllTitlesSectionHeaderView else {
            return UIView()
        }
        sectionHeader.configureWith(title: "All titles")
        
        if tableSection.canBeFiltered && tableSection.canBeShared {
            sectionHeader.showShareAndFilterButtons()
        } else if tableSection.canBeFiltered {
            sectionHeader.showOnlyFilterButton()
        } else {
            sectionHeader.showOnlyShareButton()
        }
        
        return sectionHeader
    }
    
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let calculatedHeight = AllTitlesSectionHeaderView.calculateEstimatedHeaderHeight()
//
//        return calculatedHeight
////        return 40
//    }

    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let calculatedHeight = AllTitlesSectionHeaderView.calculateEstimatedHeaderHeight()
        return calculatedHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func configureNavBar() {
        super.configureNavBar()
        var text = tableSection.sectionTitle
        text = text.replacingOccurrences(of: "\n", with: " ")
        title = text
        
        extendedLayoutIncludesOpaqueBars = true
        navigationItem.backButtonTitle = ""
    }
    
    override func adjustNavBarAppearanceFor(currentOffsetY: CGFloat) {
        if currentOffsetY > tableViewInitialOffsetY && navigationController?.navigationBar.standardAppearance != Utils.visibleNavBarAppearance {
            navigationController?.navigationBar.standardAppearance = Utils.visibleNavBarAppearance
//            print("to visible")
        }
        
        if currentOffsetY <= tableViewInitialOffsetY && navigationController?.navigationBar.standardAppearance != Utils.transparentNavBarAppearance {
            navigationController?.navigationBar.standardAppearance = Utils.transparentNavBarAppearance
//            print("to transparent")
        }
    }

}
