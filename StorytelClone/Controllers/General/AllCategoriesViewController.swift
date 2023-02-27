//
//  AllCategoriesViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class AllCategoriesViewController: BaseTableViewController {
    
    private let vcTitle = "Todas las categorías"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVc()
        configureNavBar()
    }
    
    private func configureVc() {
        bookTable.register(CategoriesTableViewCellWithCollection.self, forCellReuseIdentifier: CategoriesTableViewCellWithCollection.identifier)
        
        bookTable.estimatedSectionHeaderHeight = 0
        
        guard let headerView = bookTable.tableHeaderView as? FeedTableHeaderView else { return }
        headerView.headerLabel.text = vcTitle
        headerView.topAnchorConstraint.constant = FeedTableHeaderView.labelTopAnchorForCategory
        
    }
    
    override func configureNavBar() {
        super.configureNavBar()
        title = vcTitle
        // Disable the automatic showing of the navigation bar during scrolling
//        navigationController?.hidesBarsOnSwipe = false
                
//        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCellWithCollection.identifier, for: indexPath) as? CategoriesTableViewCellWithCollection else { return UITableViewCell() }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (Utils.calculatedCvItemSizeCategory.height * 10) + (Constants.cvPadding * 9) + Constants.gapBetweenSectionsOfTablesWithSquareCovers
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 41
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if !isInitialOffsetYSet {
            tableViewInitialOffsetY = scrollView.contentOffset.y
            isInitialOffsetYSet = true
            print("hide navbar background, offsetY = \(scrollView.contentOffset.y)")
            navigationController?.makeTransparent()
        } else {
            let currentOffsetY = scrollView.contentOffset.y
            guard let tableHeaderHeight = bookTable.tableHeaderView?.bounds.size.height else { return }
            
            if currentOffsetY <= tableViewInitialOffsetY + tableHeaderHeight + 10 {
                print("hide navbar background, offsetY = \(scrollView.contentOffset.y)")
                navigationController?.makeTransparent()
            } else {
                print("SHOW NAVBAR background, offsetY = \(scrollView.contentOffset.y)")
                navigationController?.makeVisible()
            }
        }
        
        
        
        
        
    
    }

}

