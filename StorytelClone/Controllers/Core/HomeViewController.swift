//
//  ViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

enum Sections: Int {
    case SoloParaTi = 0
    case CrecimientoPersonalRecomendados = 1
    case CrecimientoPersonalPopulares = 2
    case PorqueTeInteresa = 3
    case NovelaRecomendados = 4
    case SeriesImageButton = 5
    case TodasLasCategoriasImageButton = 6
}

class HomeViewController: UIViewController {
    
    private let sectionTitles = ["Solo para ti", "Crecimiento personal: Recomendados para ti", "Crecimiento personal: Los más populares", "Porque te interesa", "Novela: Recomendados para ti", "", ""]
    private let sectionSubtitles = ["", "", "", "Alice's Adventures in Wonderland", "", "", ""]
        
    private var tableViewInitialOffsetY: Double = 0
    private var isInitialOffsetYSet = false
    
    private var tableHeaderView: FeedTableHeaderView?
    
    private let feedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(TableViewCellWithCollection.self, forCellReuseIdentifier: TableViewCellWithCollection.identifier)
        table.register(WideButtonTableViewCell.self, forCellReuseIdentifier: WideButtonTableViewCell.identifier)
        table.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        
        table.backgroundColor = .systemBackground
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
        
        // Avoid gaps between sections and custom section headers
        table.sectionFooterHeight = 0
        
        // Avoid gap at the very bottom of the table view
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        table.contentInset = inset
        
        return table
    }()

    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavBar()
        
        view.addSubview(feedTable)
        feedTable.delegate = self
        feedTable.dataSource = self

        tableHeaderView = FeedTableHeaderView(frame: .zero)
        feedTable.tableHeaderView = tableHeaderView
        feedTable.showsHorizontalScrollIndicator = false
    
        configureHeader()

        NotificationCenter.default.addObserver(self, selector: #selector(didChangeContentSizeCategory), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableHeaderView?.updateGreetingsLabel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedTable.frame = view.bounds
    }

}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 5 || indexPath.section == 6 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WideButtonTableViewCell.identifier, for: indexPath) as? WideButtonTableViewCell else { return UITableViewCell()}
            // Using hardcoded data
            if indexPath.section == 5 {
                cell.wideButtonLabel.text = "Series"
            } else {
                cell.wideButtonLabel.text = "Todas las categorías"
            }
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == tableView.numberOfSections - 1 || indexPath.section == tableView.numberOfSections - 2 {
            return WideButtonTableViewCell.heightForRow
        }
        return Constants.heightForRowWithSquareCoversCv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == tableView.numberOfSections - 2 {
            return Constants.gapBetweenSectionsOfTablesWithSquareCovers
        } else if section == feedTable.numberOfSections - 1 {
            return 0
        } else {
            let sectionHeight = SectionHeaderView.calculateSectionHeightWith(title: sectionTitles[section], subtitle: sectionSubtitles[section])
            return sectionHeight
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != tableView.numberOfSections - 1, section != tableView.numberOfSections - 2 else { return nil }
        guard let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView else { return UITableViewHeaderFooterView() }
        
        sectionHeaderView.sectionTitleLabel.text = sectionTitles[section]
        sectionHeaderView.sectionSubtitleLabel.text = sectionSubtitles[section]
        
        if sectionSubtitles[section].isEmpty {
            sectionHeaderView.hasSubtitle = false
        }
        
        return sectionHeaderView
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let font = Utils.navBarTitleFont
        
        if !isInitialOffsetYSet {
            tableViewInitialOffsetY = scrollView.contentOffset.y
            isInitialOffsetYSet = true
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear, NSAttributedString.Key.font : font]
        } else {
            let currentOffsetY = scrollView.contentOffset.y
            navigationController?.navigationBar.titleTextAttributes = currentOffsetY > tableViewInitialOffsetY ? [NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font : font] : [NSAttributedString.Key.foregroundColor : UIColor.clear, NSAttributedString.Key.font : font]
        }
    }

}


// MARK: - Helper methods
extension HomeViewController {
    
    @objc private func didChangeContentSizeCategory() {
        print("notification, table header configured, reloadData")
        configureHeader()
        feedTable.reloadData()
    }
    
    private func configureNavBar() {
        title = "Home"
//        navigationItem.title = "Home"
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "bell", withConfiguration: configuration)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .label
    }
    
    func configureHeader() {
        tableHeaderView?.updateGreetingsLabel()

        guard let tableHeader = tableHeaderView,
              let greetingsLabel = tableHeaderView?.greetingsLabel else { return }

        let currentText = greetingsLabel.text

        // Create greetingsLabel to get actual scaled font size
        let label = FeedTableHeaderView.createGreetingsLabel()
        label.text = currentText

        // Calculate the label's size to fit its content
        let size = label.sizeThatFits(CGSize(width: label.preferredMaxLayoutWidth, height: .greatestFiniteMagnitude))

        // Get the calculated height of the label
        let labelHeight = size.height

        let headerHeight = labelHeight + FeedTableHeaderView.greetingsLabelTopAnchorConstant + FeedTableHeaderView.greetingsLabelBottomAnchorConstant

        tableHeader.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight)
    }
    
}

