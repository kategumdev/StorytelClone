//
//  AllTitlesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 31/3/23.
//

import UIKit

class AllTitlesViewController: BaseTableViewController {

    let tableSection: TableSection
    let categoryOfParentVC: Category
    
    let books = Book.books
    
    init(tableSection: TableSection, categoryOfParentVC: Category) {
        self.tableSection = tableSection
        self.categoryOfParentVC = categoryOfParentVC
        super.init(categoryModel: categoryOfParentVC, tableViewStyle: .plain)
        #warning("This category is not needed in this vc, only needed for BaseTableViewController initializer")
    }
    
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
        customizeBookTable()
    }
    
    private func customizeBookTable() {
        bookTable.register(AllTitlesSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: AllTitlesSectionHeaderView.identifier)
        
        guard let headerView = bookTable.tableHeaderView as? FeedTableHeaderView else { return }
        headerView.headerLabel.text = tableSection.sectionTitle
        headerView.topAnchorConstraint.constant = FeedTableHeaderView.labelTopAnchorForCategoryOrSectionTitle
    }
    
    // MARK: - Superclass overrides
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(books.count) BOOKS")
        return books.count
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
//        sectionHeader.showOnlyFilterButton()
        sectionHeader.showOnlyShareButton()
        
        
//        sectionHeader.shareButton.isHidden = true
//        sectionHeader.vertBarView.isHidden = true
//        sectionHeader.stackShareFilter.removeArrangedSubview(sectionHeader.filterButton)
//        let spacerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 5, height: 5)))
//        let spacerView = UIView()
//        spacerView.translatesAutoresizingMaskIntoConstraints = false
//        spacerView.widthAnchor.constraint(equalToConstant: 8).isActive = true
//        spacerView.heightAnchor.constraint(equalToConstant: 8).isActive = true
//        spacerView.backgroundColor = .blue
//        [spacerView, sectionHeader.filterButton].forEach { sectionHeader.stackShareFilter.addArrangedSubview($0) }
//        sectionHeader.stackShareFilter.addArrangedSubview(sectionHeader.filterButton)
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
