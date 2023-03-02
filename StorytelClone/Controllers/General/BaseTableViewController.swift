//
//  BaseTableVIewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class BaseTableViewController: UIViewController {
    
    let vcCategory: Category
    
    private var previousContentSize: CGSize = CGSize(width: 0, height: 0)
    
    let transparentAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear, NSAttributedString.Key.font : Utils.navBarTitleFontScaled]
        appearance.configureWithTransparentBackground()
        return appearance
    }()
    
    let visibleAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = .tertiaryLabel
        appearance.backgroundEffect = UIBlurEffect(style: .systemThickMaterial)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font : Utils.navBarTitleFontScaled]
        return appearance
    }()
        
    var tableViewInitialOffsetY: Double = 0
    var isInitialOffsetYSet = false
    private var isFirstTime = true
    private var lastVisibleRowIndexPath = IndexPath(row: 0, section: 0)
 
    let bookTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
//        table.backgroundColor = .systemBackground
        table.backgroundColor = Utils.customBackgroundColor
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
        
        // Avoid gap at the very bottom of the table view
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        table.contentInset = inset
        
        table.register(TableViewCellWithCollection.self, forCellReuseIdentifier: TableViewCellWithCollection.identifier)
//        table.register(CategoriesTableViewCellWithCollection.self, forCellReuseIdentifier: CategoriesTableViewCellWithCollection.identifier)
//        table.register(WideButtonTableViewCell.self, forCellReuseIdentifier: WideButtonTableViewCell.identifier)
        
        table.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        
        // Avoid gaps between sections and custom section headers
        table.sectionFooterHeight = 0
        
        // Enable self-sizing of section headers according to their subviews auto layout (must not be 0)
//        table.estimatedSectionHeaderHeight = 60
        
        table.tableHeaderView = FeedTableHeaderView()
        // These two lines avoid constraints' conflict of header and its label when view just loaded
        table.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        table.tableHeaderView?.fillSuperview()
        
        return table
    }()

    
    init(model: Category) {
        self.vcCategory = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        view.addSubview(bookTable)
        bookTable.delegate = self
        bookTable.dataSource = self
        
        configureNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
        bookTable.frame = view.bounds
        layoutHeaderView()
    }
    
    func configureNavBar() {
//        title = vcCategory.title
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.standardAppearance = transparentAppearance
    }

}

extension BaseTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vcCategory.tableSections.count
    }
    
    // This has to be overriden by subclasses
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Utils.heightForRowWithHorizontalCv
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView else { return UITableViewHeaderFooterView() }
        
        sectionHeaderView.configureFor(section: vcCategory.tableSections[section])
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let calculatedHeight = SectionHeaderSubviewsContainer.calculateHeaderHeightFor(section: vcCategory.tableSections[section])
        print("calculated height for section \(section): \(calculatedHeight)")
        return calculatedHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        print("height for section \(section): \(view.bounds.size.height)")
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == vcCategory.tableSections.count - 1 {
            return Constants.gapBetweenSectionsOfCategoryTable
        } else {
            return 0
        }
    }
    
    // Override in subclasses of this vc if no dimming behavior for table header is needed
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y

        guard isInitialOffsetYSet else {
            tableViewInitialOffsetY = scrollView.contentOffset.y
            isInitialOffsetYSet = true
//            print("initialOffsetY is SET")
            return
        }

        // Toggle navbar from transparent to visible at calculated contentOffset
        guard let tableHeaderHeight = bookTable.tableHeaderView?.bounds.size.height else { return }
        
        changeHeaderDimViewAlphaWith(currentOffsetY: currentOffsetY)
        
        if currentOffsetY > tableViewInitialOffsetY + tableHeaderHeight + 10 && navigationController?.navigationBar.standardAppearance != visibleAppearance {
            navigationController?.navigationBar.standardAppearance = visibleAppearance
//            print("to visible")
        }
        
        if currentOffsetY <= tableViewInitialOffsetY + tableHeaderHeight + 10 && navigationController?.navigationBar.standardAppearance != transparentAppearance {
            navigationController?.navigationBar.standardAppearance = transparentAppearance
//            print("to transparent")
        }
    }
    
}

// MARK: - Helper methods
extension BaseTableViewController {

    func layoutHeaderView() {
                print("layoutHeaderView")
        guard let headerView = bookTable.tableHeaderView else { return }
//        (headerView as? FeedTableHeaderView)?.updateGreetingsLabel()
        if headerView.translatesAutoresizingMaskIntoConstraints != true {
//                        print("translatesAutoresizingMask set to true")
            headerView.translatesAutoresizingMaskIntoConstraints = true
        }
        
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
                        print("header frame adjusted")
            headerView.frame.size.height = size.height
            bookTable.tableHeaderView = headerView

            guard isFirstTime == true else { return }
            isFirstTime = false
            // Force vc to call viewDidLayoutSubviews second time to correctly layout table header
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
        
    }
    
    private func changeHeaderDimViewAlphaWith(currentOffsetY offsetY: CGFloat) {
        guard let tableHeader = bookTable.tableHeaderView as? FeedTableHeaderView else { return }
        
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
