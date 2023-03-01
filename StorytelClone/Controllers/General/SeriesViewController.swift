//
//  SeriesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class SeriesViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let headerView = bookTable.tableHeaderView as? FeedTableHeaderView else { return }
        headerView.headerLabel.text = vcCategory.title
        headerView.topAnchorConstraint.constant = FeedTableHeaderView.labelTopAnchorForCategory
        
        navigationItem.backButtonTitle = ""

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }
        
        return cell
    }
    
    override func configureNavBar() {
        super.configureNavBar()
        var text = vcCategory.title
        text = text.replacingOccurrences(of: "\n", with: " ")
        title = text
    }
    
}
