//
//  SeriesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class SeriesViewController: BaseTableViewController {
    
    private let vcTitle = "Series"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVc()
        configureNavBar()

    }
    
    private func configureVc() {
        sectionTitles = ["Series que son tendencia", "Las mejores series originales"]
        sectionSubtitles = ["", ""]
        
        guard let headerView = bookTable.tableHeaderView as? FeedTableHeaderView else { return }
        headerView.headerLabel.text = vcTitle
        headerView.topAnchorConstraint.constant = FeedTableHeaderView.labelTopAnchorForCategory
    }
    
    override func configureNavBar() {
        super.configureNavBar()
        title = vcTitle
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }
        return cell
    }
    

}
