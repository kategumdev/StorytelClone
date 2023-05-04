//
//  ProfileViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

enum ProfileCell: String, CaseIterable {
    case myReviews = "My reviews"
    case thingsIFollow = "Things I follow"
    case listeningGoal = "Listening Goal"
    case statistics = "Statistics"
    
    var image: UIImage? {
        switch self {
        case .myReviews: return UIImage(systemName: "star")
        case .thingsIFollow: return UIImage(systemName: "checkmark.circle")
        case .listeningGoal: return UIImage(systemName: "target")
        case .statistics: return UIImage(systemName: "chart.bar.xaxis")
        }
    }
}

class ProfileViewController: UIViewController {
    // MARK: - Static properties
    static let cellLabelFont = UIFont.preferredCustomFontWith(weight: .medium, size: 17)
    static let maximumPointSizeForScaledCellLabelFont: CGFloat = 39
    
    // MARK: - Instance properties
    private let profileCells = ProfileCell.allCases
    private var tableViewInitialOffsetY: Double = 0
    private var isInitialOffsetYSet = false
    private var scaledCellLabelFont = UIFontMetrics.default.scaledFont(for: ProfileViewController.cellLabelFont, maximumPointSize: maximumPointSizeForScaledCellLabelFont)
    
//    private var tableHeader = PersonTableHeaderView()
    private var contentSizeCategoryChanged = false
    private var timeExtraLayout = 0
    
    private let profileTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = Utils.customBackgroundColor
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
        table.allowsSelection = false
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
//        table.tableHeaderView = PersonTableHeaderView()
//        table.tableHeaderView = tableHeader

        return table
    }()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        configureNavBar()
        
        view.addSubview(profileTable)
//        profileTable.translatesAutoresizingMaskIntoConstraints = false
//        profileTable.fillSuperview()
//        profileTable.tableHeaderView = PersonTableHeaderView()
//        profileTable.tableHeaderView = tableHeader
        profileTable.delegate = self
        profileTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews of ProfileVC")
        profileTable.frame = view.bounds
        
        
        profileTable.tableHeaderView = PersonTableHeaderView()
        guard let tableHeader = profileTable.tableHeaderView else { return }
        Utils.layoutTableHeaderView(tableHeader, inTableView: profileTable)
//        if timeExtraLayout != 0 && timeExtraLayout <= 3 {
//            print("\n LAYOUT")
//            timeExtraLayout -= 1
////            profileTable.frame = view.bounds
//
//            view.setNeedsLayout()
//            view.layoutIfNeeded()
//        }
//        guard let tableHeader = profileTable.tableHeaderView else { return }
//        Utils.layoutTableHeader(tableHeader, inTableView: profileTable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.adjustAppearanceTo(currentOffsetY: profileTable.contentOffset.y, offsetYToCompareTo: tableViewInitialOffsetY, withVisibleTitleWhenTransparent: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            scaledCellLabelFont = UIFontMetrics.default.scaledFont(for: ProfileViewController.cellLabelFont, maximumPointSize: ProfileViewController.maximumPointSizeForScaledCellLabelFont)
//            print("TRAIT")
//            contentSizeCategoryChanged = true
//            timeExtraLayout = 3
        }
    }

   // MARK: - Helper methods
    private func configureNavBar() {
        title = "Profile"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.makeNavbarAppearance(transparent: true)
        navigationItem.backButtonTitle = ""
    }
    
//    private func layoutTableHeader() {
//       
//    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.tintColor = Utils.unactiveElementColor
        cell.accessoryType = .disclosureIndicator

        let profileCell = profileCells[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.image = profileCell.image
        content.text = profileCell.rawValue
        content.textProperties.font = scaledCellLabelFont
        content.textProperties.color = Utils.unactiveElementColor
        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let profileCell = profileCells[indexPath.row]
        let label = UILabel()
        label.font = scaledCellLabelFont
        label.text = profileCell.rawValue
        
        let labelHeight = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).height
        let padding: CGFloat = 30
        return labelHeight + padding
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        guard isInitialOffsetYSet else {
            tableViewInitialOffsetY = scrollView.contentOffset.y
            isInitialOffsetYSet = true
            return
        }
        
        // Toggle navbar from transparent to visible depending on current contentOffset.y
        navigationController?.adjustAppearanceTo(currentOffsetY: currentOffsetY, offsetYToCompareTo: tableViewInitialOffsetY, withVisibleTitleWhenTransparent: true)
    }
    
}

