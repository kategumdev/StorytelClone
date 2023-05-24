//
//  BaseViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - Instance properties
    var category: Category?
    let tableViewStyle: UITableView.Style
    
    private var previousContentSize: CGSize = CGSize(width: 0, height: 0)
    var tableViewInitialOffsetY: Double = 0
    var isInitialOffsetYSet = false
    private var lastVisibleRowIndexPath = IndexPath(row: 0, section: 0)
    
    lazy var dimmedAnimationButtonDidTapCallback: DimmedAnimationButtonDidTapCallback = { [weak self] controller in
        self?.navigationController?.pushViewController(controller, animated: true)
    }
    
    lazy var bookTable: UITableView = {
        let table = UITableView(frame: .zero, style: tableViewStyle)
        table.backgroundColor = UIColor.customBackgroundColor
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
        table.allowsSelection = false
        
        table.register(TableViewCellWithCollection.self, forCellReuseIdentifier: TableViewCellWithCollection.identifier)
        table.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        
        table.sectionFooterHeight = 0 // Avoid gaps between sections and custom section headers
        table.sectionHeaderTopPadding = 0 // Avoid gap above custom section header

        // Avoid gap at the very bottom of the table view
        table.tableFooterView = UIView()
        table.tableFooterView?.frame.size.height = SectionHeaderView.topPadding
        return table
    }()
 
    // MARK: - Initializers
    init(categoryModel: Category? = nil, tableViewStyle: UITableView.Style = .grouped) {
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
        view.backgroundColor = UIColor.customBackgroundColor
        view.addSubview(bookTable)
        bookTable.delegate = self
        bookTable.dataSource = self
        bookTable.tableHeaderView = TableHeaderView()
        configureNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bookTable.frame = view.bounds
        layoutTableHeader()
//        guard let tableHeader = bookTable.tableHeaderView else { return }
//        Utils.layoutTableHeaderView(tableHeader, inTableView: bookTable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustNavBarAppearanceTo(currentOffsetY: bookTable.contentOffset.y)
    }
    
    // MARK: - Instance methods
    func configureNavBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.makeNavbarAppearance(transparent: true)
        navigationItem.backButtonTitle = ""
    }
    
    func adjustNavBarAppearanceTo(currentOffsetY: CGFloat) {
        var offsetYToCompareTo: CGFloat = tableViewInitialOffsetY
        if (self is CategoryViewController && category?.bookToShowMoreTitlesLikeIt == nil) || self is AllCategoriesViewController {
            if let tableHeaderHeight = bookTable.tableHeaderView?.bounds.size.height {
                offsetYToCompareTo = tableViewInitialOffsetY + tableHeaderHeight + 10
                changeHeaderDimViewAlphaWith(currentOffsetY: currentOffsetY)
            }
        }
        
        let visibleTitleWhenTransparent: Bool = category?.bookToShowMoreTitlesLikeIt != nil
        navigationController?.adjustAppearanceTo(currentOffsetY: currentOffsetY, offsetYToCompareTo: offsetYToCompareTo, withVisibleTitleWhenTransparent: visibleTitleWhenTransparent)
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
    
    func layoutTableHeader() {
        guard let tableHeader = bookTable.tableHeaderView else { return }
        Utils.layoutTableHeaderView(tableHeader, inTableView: bookTable)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension BaseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let category = category else { return 0 }
        return category.tableSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableViewCellWithCollection.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let category = category else { return UIView() }
        let sectionKind = category.tableSections[section].sectionKind
        guard sectionKind != .seriesCategoryButton, sectionKind != .allCategoriesButton else { return UIView() }
        guard let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView else { return UIView() }
        let tableSection = category.tableSections[section]
        
        sectionHeader.configureFor(tableSection: tableSection, sectionNumber: section, category: category, withSeeAllButtonDidTapCallback: { [weak self] in
            guard let self = self else { return }
            if let tableSectionCategory = tableSection.toShowCategory {
                let controller = CategoryViewController(categoryModel: tableSectionCategory)
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                let controller = AllTitlesViewController(tableSection: tableSection, titleModel: tableSection.toShowTitleModel)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        })
        return sectionHeader
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        // If all categories have sections, this checking is not needed, just use calculateEstimatedHeightFor
        guard let category = category else { return 0 }
        if !category.tableSections.isEmpty {
            let tableSection = category.tableSections[section]
            return SectionHeaderView.calculateEstimatedHeightFor(tableSection: tableSection, superviewWidth: view.bounds.width, sectionNumber: section, category: category)
        }
        return 0
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
