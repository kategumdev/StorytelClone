//
//  BaseTableVIewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 27/2/23.
//

import UIKit

class BaseTableViewController: UIViewController {
    
    var sectionTitles = [String]()
    var sectionSubtitles = [String]()
        
    private var tableViewInitialOffsetY: Double = 0
    private var isInitialOffsetYSet = false
//    private var allSectionHeaderHeight = [Int : CGFloat]()
    private var isFirstTime = true
    private var lastVisibleRowIndexPath = IndexPath(row: 0, section: 0)
 
    let bookTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .systemBackground
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
        
        // Avoid gap at the very bottom of the table view
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        table.contentInset = inset
        
        table.register(TableViewCellWithCollection.self, forCellReuseIdentifier: TableViewCellWithCollection.identifier)
//        table.register(WideButtonTableViewCell.self, forCellReuseIdentifier: WideButtonTableViewCell.identifier)
        table.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        
        // Avoid gaps between sections and custom section headers
        table.sectionFooterHeight = 0
        
        // Enable self-sizing of section headers according to their subviews auto layout (must not be 0)
        table.estimatedSectionHeaderHeight = 60
        
        table.tableHeaderView = FeedTableHeaderView()
        // These two lines avoid constraints' conflict of header and its label when view just loaded
        table.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        table.tableHeaderView?.fillSuperview()
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(bookTable)
        bookTable.delegate = self
        bookTable.dataSource = self
        
//        configureNavBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("viewDidLayoutSubviews")
        bookTable.frame = view.bounds
        layoutHeaderView()
    }
    
    func configureNavBar() {
//        title = "Home"
//        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
//        let image = UIImage(systemName: "bell", withConfiguration: configuration)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .label
    }
    

}

extension BaseTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    // This has to be overriden by subclass
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRowWithSquareCoversCv
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView else { return UITableViewHeaderFooterView() }
        
        sectionHeaderView.sectionTitleLabel.text = sectionTitles[section]
        sectionHeaderView.sectionSubtitleLabel.text = sectionSubtitles[section]
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
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
extension BaseTableViewController {
    
    
    //    @objc private func didChangeContentSizeCategory() {
    //        print("notification")
    //        feedTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    //        feedTable.scrollToRow(at: lastVisibleRowIndexPath, at: .none, animated: false)
    //    }
    
    @objc func appWillResignActive() {
        // Do something when the app is about to move to the background
        lastVisibleRowIndexPath = bookTable.indexPathsForVisibleRows?.last ?? IndexPath(row: 0, section: 0)
        //        print("last visible row before background: \(lastVisibleRowIndexPath)")
    }
    
//    func configureNavBar() {
////        title = "Home"
////        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
////        let image = UIImage(systemName: "bell", withConfiguration: configuration)
////        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
//        navigationItem.backButtonTitle = ""
//        navigationController?.navigationBar.tintColor = .label
//    }
    
    private func layoutHeaderView() {
        //        print("layoutHeaderView")
        guard let headerView = bookTable.tableHeaderView else { return }
//        (headerView as? FeedTableHeaderView)?.updateGreetingsLabel()
        if headerView.translatesAutoresizingMaskIntoConstraints != true {
            //            print("translatesAutoresizingMask set to true")
            headerView.translatesAutoresizingMaskIntoConstraints = true
        }
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            //            print("header frame adjusted")
            headerView.frame.size.height = size.height
            bookTable.tableHeaderView = headerView
            
            // Avoid glitch while scrolling up after dynamic font size change
            guard isFirstTime == true else {
                
                // Avoid scrolling up and back if table view offset is as initial
                if tableViewInitialOffsetY != bookTable.contentOffset.y {
                    bookTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                    bookTable.scrollToRow(at: lastVisibleRowIndexPath, at: .none, animated: false)
                }
                return
            }
            isFirstTime = false
        }
    }
}
