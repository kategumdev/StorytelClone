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
    
    // MARK: - Instance properties
    private let profileCells = ProfileCell.allCases
    private var tableViewInitialOffsetY: Double = 0
    private var isInitialOffsetYSet = false
    
    private let profileTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.customBackgroundColor
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
        table.allowsSelection = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        return table
    }()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customBackgroundColor
        configureNavBar()
        view.addSubview(profileTable)
        profileTable.delegate = self
        profileTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureAndLayoutTableHeader()
//        profileTable.frame = view.bounds
//
//        var tableHeader = PersonTableHeaderView(kind: .forProfile)
//        tableHeader.getStartedButtonDidTapCallback = { [weak self] in
//            let controller = UINavigationController(rootViewController: RegisterViewController())
//            self?.present(controller, animated: true)
//        }
//        profileTable.tableHeaderView = tableHeader
//        Utils.layoutTableHeaderView(tableHeader, inTableView: profileTable)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.adjustAppearanceTo(currentOffsetY: profileTable.contentOffset.y, offsetYToCompareTo: tableViewInitialOffsetY, withVisibleTitleWhenTransparent: true)
    }

   // MARK: - Helper methods
    private func configureNavBar() {
        title = "Profile"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.makeAppearance(transparent: true)
        navigationItem.backButtonTitle = ""
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let image = UIImage(systemName: "gearshape", withConfiguration: symbolConfig)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(handleGearButtonTapped))
    }
    
    @objc func handleGearButtonTapped() {
        let controller = SettingsViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func getScaledCellLabelFont() -> UIFont {
        return UIFont.createScaledFontWith(textStyle: .body, weight: .medium, maxPointSize: 39)
    }
    
    private func configureAndLayoutTableHeader() {
        profileTable.frame = view.bounds
        
        let tableHeader = PersonTableHeaderView(kind: .forProfile)
        tableHeader.getStartedButtonDidTapCallback = { [weak self] in
            let controller = UINavigationController(rootViewController: LoginRegisterViewController(stackViewKind: .register))
            controller.modalPresentationStyle = .overFullScreen
            self?.present(controller, animated: true)
        }
        
        tableHeader.logInButtonDidTapCallback = { [weak self] in
            let controller = UINavigationController(rootViewController: LoginRegisterViewController(stackViewKind: .login))
            controller.modalPresentationStyle = .overFullScreen
            self?.present(controller, animated: true)
        }
        
        profileTable.tableHeaderView = tableHeader
        Utils.layoutTableHeaderView(tableHeader, inTableView: profileTable)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.tintColor = UIColor.unactiveElementColor
        cell.accessoryType = .disclosureIndicator

        let profileCell = profileCells[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.image = profileCell.image
        content.text = profileCell.rawValue
        content.textProperties.font = getScaledCellLabelFont()
        content.textProperties.color = UIColor.unactiveElementColor
        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let profileCell = profileCells[indexPath.row]
        let label = UILabel()
        label.font = getScaledCellLabelFont()
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

