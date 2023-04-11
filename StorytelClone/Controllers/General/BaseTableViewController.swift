//
//  BaseTableVIewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class BaseTableViewController: UIViewController {
    
    // MARK: - Instance properties
    let category: Category
    let tableViewStyle: UITableView.Style
    
    private var previousContentSize: CGSize = CGSize(width: 0, height: 0)
    var tableViewInitialOffsetY: Double = 0
    var isInitialOffsetYSet = false
    private var isFirstTime = true
    private var lastVisibleRowIndexPath = IndexPath(row: 0, section: 0)
    
    lazy var bookTable: UITableView = {
//        let table = UITableView(frame: .zero, style: .grouped)
        let table = UITableView(frame: .zero, style: tableViewStyle)
        table.backgroundColor = Utils.customBackgroundColor
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
        table.allowsSelection = false
        
        // Avoid gap at the very bottom of the table view
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        table.contentInset = inset
        
        table.register(TableViewCellWithCollection.self, forCellReuseIdentifier: TableViewCellWithCollection.identifier)
        table.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        table.register(NoButtonSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: NoButtonSectionHeaderView.identifier)
        
        // Avoid gaps between sections and custom section headers
        table.sectionFooterHeight = 0
        
        // Avoid gap above custom section header
        table.sectionHeaderTopPadding = 0
        
        // Enable self-sizing of section headers according to their subviews auto layout (must not be 0)
//        table.estimatedSectionHeaderHeight = 60
        
//        table.tableHeaderView = FeedTableHeaderView()
//        // These two lines avoid constraints' conflict of header and its label when view just loaded
//        table.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
//        table.tableHeaderView?.fillSuperview()
        
        return table
    }()
 
    // MARK: - Initializers
    init(categoryModel: Category, tableViewStyle: UITableView.Style = .grouped) {
        self.category = categoryModel
        self.tableViewStyle = tableViewStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        view.addSubview(bookTable)
        bookTable.delegate = self
        bookTable.dataSource = self
        addTableHeaderView()
        configureNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bookTable.frame = view.bounds
        layoutHeaderView()
    }
    
    // MARK: - Instance methods
    func addTableHeaderView() {
        bookTable.tableHeaderView = TableHeaderView()
        // These two lines avoid constraints' conflict of header and its label when view just loaded
        bookTable.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        bookTable.tableHeaderView?.fillSuperview()
    }

    func configureNavBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.makeNavbarAppearance(transparent: true)
        navigationItem.backButtonTitle = ""
    }
    
    func adjustNavBarAppearanceTo(currentOffsetY: CGFloat) {
        guard let tableHeaderHeight = bookTable.tableHeaderView?.bounds.size.height else { return }
        
        changeHeaderDimViewAlphaWith(currentOffsetY: currentOffsetY)
        
        let offsetYToCompareTo = tableViewInitialOffsetY + tableHeaderHeight + 10
        navigationController?.adjustAppearanceTo(currentOffsetY: currentOffsetY, offsetYToCompareTo: offsetYToCompareTo)
    }
    
    func layoutHeaderView() {
        guard let headerView = bookTable.tableHeaderView else { return }
        if headerView.translatesAutoresizingMaskIntoConstraints != true {
            headerView.translatesAutoresizingMaskIntoConstraints = true
        }
        
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
//            print("header frame adjusted")
            headerView.frame.size.height = size.height
            bookTable.tableHeaderView = headerView

            guard isFirstTime == true else { return }
            isFirstTime = false
            // Force vc to call viewDidLayoutSubviews second time to correctly layout table header
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    // MARK: - Helper methods
    private func changeHeaderDimViewAlphaWith(currentOffsetY offsetY: CGFloat) {
        guard let tableHeader = bookTable.tableHeaderView as? TableHeaderView else { return }
        
        let height = tableHeader.bounds.size.height + 10
        let maxOffset = tableViewInitialOffsetY + height
        
        if offsetY <= tableViewInitialOffsetY && tableHeader.dimView.alpha != 0 {
            tableHeader.dimView.alpha = 0
        } else if offsetY >= maxOffset && tableHeader.dimView.alpha != 1 {
            tableHeader.dimView.alpha = 1
        } else if offsetY > tableViewInitialOffsetY && offsetY < maxOffset {
            let alpha = (offsetY + abs(tableViewInitialOffsetY)) / height
            tableHeader.dimView.alpha = alpha
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension BaseTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return category.tableSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Utils.heightForRowWithHorizontalCv
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionKind = category.tableSections[section].sectionKind

        guard sectionKind != .seriesCategoryButton, sectionKind != .allCategoriesButton else { return UIView()}
        
        if sectionKind == .poster || sectionKind == .oneBookWithOverview || sectionKind == .largeCoversHorizontalCv || sectionKind == .verticalCv {
            guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoButtonSectionHeaderView.identifier) as? NoButtonSectionHeaderView else { return UIView() }
            
            sectionHeader.configureFor(section: category.tableSections[section])
            return sectionHeader
        } else {
            guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView else { return UIView() }

            sectionHeader.configureFor(section: category.tableSections[section])

            // Respond to seeAllButton in section header
            sectionHeader.containerWithSubviews.callback = { [weak self] tableSection in
                guard let self = self else { return }
                let controller = AllTitlesViewController(tableSection: tableSection, categoryOfParentVC: self.category, titleModel: nil)

                self.navigationController?.pushViewController(controller, animated: true)
            }
            return sectionHeader
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let sectionKind = category.tableSections[section].sectionKind
        
        if sectionKind == .poster || sectionKind == .oneBookWithOverview || sectionKind == .largeCoversHorizontalCv || sectionKind == .verticalCv {

            // Get height for headers with no button
            let calculatedHeight = NoButtonSectionHeaderView.calculateHeaderHeightFor(section: category.tableSections[section])
            return calculatedHeight
        } else {
            let calculatedHeight = SectionHeaderView.calculateHeaderHeightFor(section: category.tableSections[section])
            return calculatedHeight
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == category.tableSections.count - 1 {
            return Constants.generalTopPaddingSectionHeader
        } else {
            return 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        guard isInitialOffsetYSet else {
            tableViewInitialOffsetY = scrollView.contentOffset.y
            isInitialOffsetYSet = true
            return
        }
        
        // Toggle navbar from transparent to visible at calculated contentOffset
        adjustNavBarAppearanceTo(currentOffsetY: currentOffsetY)
    }
    
}
