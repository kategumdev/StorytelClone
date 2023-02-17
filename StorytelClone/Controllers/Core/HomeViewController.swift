//
//  ViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 14/2/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    var tableViewInitialOffsetY: Double = 0
    var initialOffsetYIsSet = false
    
    private var tableHeaderView: FeedTableHeaderView?
    
    private let feedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(TableViewCellWithCollection.self, forCellReuseIdentifier: TableViewCellWithCollection.identifier)
        table.backgroundColor = .systemBackground
        table.showsVerticalScrollIndicator = false
        table.separatorColor = UIColor.clear
//        table.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
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
        applyConstraintsForTableHeaderView()
        print("viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableHeaderView?.updateGreetingsLabel()
        print("viewWillAppear")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedTable.frame = view.bounds
        
        sizeHeaderToFit()
        print("viewDidLayoutSubviews")
    }

}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithCollection.identifier, for: indexPath) as? TableViewCellWithCollection else { return UITableViewCell() }
        cell.backgroundColor = .green
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "title"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("didScroll")
        
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 16)
        
        if !initialOffsetYIsSet {
            tableViewInitialOffsetY = scrollView.contentOffset.y
            initialOffsetYIsSet = true
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear, NSAttributedString.Key.font : font]
        } else {
            let currentOffsetY = scrollView.contentOffset.y
            navigationController?.navigationBar.titleTextAttributes = currentOffsetY > tableViewInitialOffsetY ? [NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font : font] : [NSAttributedString.Key.foregroundColor : UIColor.clear, NSAttributedString.Key.font : font]
        }
    }

}


// MARK: - Helper methods
extension HomeViewController {
    private func configureNavBar() {
        title = "Home"
//        navigationItem.title = "Home"
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "bell", withConfiguration: configuration)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .label
//        navigationController?.navigationBar.isTranslucent = true
        
    }
    
    func sizeHeaderToFit() {
        guard let tableHeaderView = tableHeaderView else { return }

        tableHeaderView.setNeedsLayout()
        tableHeaderView.layoutIfNeeded()

        let height = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = tableHeaderView.frame
        frame.size.height = height
        tableHeaderView.frame = frame

        feedTable.tableHeaderView = tableHeaderView
    }
    
    private func applyConstraintsForTableHeaderView() {
        guard let headerView = tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: headerView.greetingsLabel.bottomAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

