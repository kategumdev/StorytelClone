//
//  SettingsViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 5/5/23.
//

import UIKit

enum SettingsCell: String {
    case account = "Account"
    case app = "App"
    case subscription = "Subscription"
    case privacy = "Privacy"
    
    case kidsMode = "Kids mode"
    case changePasscode = "Change passcode"
    
    case helpCenter = "Help center"
    case signUp = "Sign up"
    
    var image: UIImage? {
        switch self {
        case .account: return UIImage(systemName: "person.circle.fill")
        case .app: return UIImage(systemName: "gearshape")
        case .subscription: return UIImage(systemName: "person.text.rectangle")
        case .privacy: return UIImage(systemName: "shield.lefthalf.filled")
        case .kidsMode: return UIImage(systemName: "figure.and.child.holdinghands")
        case .changePasscode: return UIImage(systemName: "lock")
        case .helpCenter: return UIImage(systemName: "questionmark")
        case .signUp: return UIImage(systemName: "iphone.and.arrow.forward")
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .account: return UIColor.unactiveElementColor
        case .app: return .label
        case .subscription: return UIColor.unactiveElementColor
        case .privacy: return UIColor.unactiveElementColor
        case .kidsMode: return .label
        case .changePasscode: return UIColor.unactiveElementColor
        case .helpCenter: return .label
        case .signUp: return .label
        }
    }
}

enum SettingsSection: String, CaseIterable {
    case general = "GENERAL"
    case kidsMode = "KIDS MODE"
    case other = "OTHER"
    
    var cells: [SettingsCell] {
        switch self {
        case .general: return [.account, .app, .subscription, .privacy]
        case .kidsMode: return [.kidsMode, .changePasscode]
        case .other: return [.helpCenter, .signUp]
        }
    }
}

class SettingsViewController: UITableViewController {
    // MARK: - Instance properties
    private let sections = SettingsSection.allCases
    private var tableViewInitialOffsetY: CGFloat = 0
    private var isInitialOffsetYSet = false
//    private let switchView = UISwitch()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customBackgroundColor
        configureNavBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.adjustAppearanceTo(currentOffsetY: tableView.contentOffset.y, offsetYToCompareTo: tableViewInitialOffsetY, withVisibleTitleWhenTransparent: true)
    }

    // MARK: - Helper methods
    private func configureNavBar() {
        title = "Settings"
        navigationController?.makeNavbarAppearance(transparent: true)
        navigationItem.backButtonTitle = ""
    }
    
    private func configureTableView() {
        // Change tableView style
        let frame = tableView.frame
        tableView = UITableView(frame: frame, style: .grouped)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.sectionHeaderTopPadding = 6
        
        // Avoid gaps between sections and custom section headers
        tableView.sectionFooterHeight = 0
        
        // Prevent scrolling if table view content size height is less than tabke frame height
        tableView.alwaysBounceVertical = false
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.backgroundColor = .clear
        
        let settingCell = sections[indexPath.section].cells[indexPath.row]
        cell.tintColor = settingCell.tintColor
        if settingCell.tintColor != .label {
            cell.selectionStyle = .none
        }
        
        var content = cell.defaultContentConfiguration()
        content.image = settingCell.image
        content.text = settingCell.rawValue
        let scaledFont = UIFont.createScaledFontWith(textStyle: .body, weight: .medium, maxPointSize: 50)
        content.textProperties.font = scaledFont
        content.textProperties.color = settingCell.tintColor
        cell.contentConfiguration = content
        
        if settingCell == .kidsMode {
            let switchView = UISwitch(frame: .zero)
            switchView.setOn(false, animated: true)
//            switchView.tag = indexPath.row // for detect which row switch Changed
//            switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchView
        } else {
            cell.accessoryType = .disclosureIndicator
//            cell.accessoryView = nil
        }
        
        // Avoid changing tableView backgroundColor after adding switchView
        tableView.backgroundColor = UIColor.customBackgroundColor
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        let settingCell = sections[indexPath.section].cells[indexPath.row]
//        if settingCell.tintColor != .label {
//            return nil
//        }
//        return indexPath
//    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        var content = headerView.defaultContentConfiguration()
        content.text = sections[section].rawValue
        content.textProperties.color = .label
        let scaledFont = UIFont.createScaledFontWith(textStyle: .caption2, weight: .medium, maxPointSize: 38)
        content.textProperties.font = scaledFont
        headerView.contentConfiguration = content
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        guard isInitialOffsetYSet else {
            tableViewInitialOffsetY = currentOffsetY
            isInitialOffsetYSet = true
            return
        }
        // Toggle navbar from transparent to visible as needed depending on current contentOffset.y
        navigationController?.adjustAppearanceTo(currentOffsetY: currentOffsetY, offsetYToCompareTo: tableViewInitialOffsetY, withVisibleTitleWhenTransparent: true)
    }
}
