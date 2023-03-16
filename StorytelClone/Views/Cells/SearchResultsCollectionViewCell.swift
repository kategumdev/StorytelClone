//
//  SearchResultsCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 11/3/23.
//

import UIKit

class SearchResultsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchResultsCollectionViewCell"
    
    private var isFirstTime = true
    
//    private lazy var tableHeaderView: UIView = {
//        let view = UIView()
//
//        let label = UILabel()
//        label.numberOfLines = 1
//        label.lineBreakMode = .byTruncatingTail
//        label.adjustsFontForContentSizeCategory = true
//        let font = Utils.sectionTitleFont
//        let scaledFont = UIFontMetrics.default.scaledFont(for: font, maximumPointSize: 45)
//        label.font = scaledFont
//        label.text = "Trending searches"
//
//        view.addSubview(label)
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.fillSuperview()
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.cvPadding),
//            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.cvPadding),
////            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//            label.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.cvPadding),
//            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.cvPadding)
//        ])
//
//        return view
//    }()
    
    let resultsTable: UITableView = {
//        let table = UITableView(frame: .zero, style: .grouped)
        let table = UITableView(frame: .zero, style: .plain)

        table.backgroundColor = Utils.customBackgroundColor
        table.separatorColor = UIColor.clear
        
        // Avoid gap at the very bottom of the table view
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        table.contentInset = inset
        
//        table.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: SearchResultsTableViewCell.identifier)
        table.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: SearchResultsTableViewCell.identifier)
        table.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        
        table.rowHeight = UITableView.automaticDimension
        
//        table.estimatedRowHeight = SearchResultsTableViewCell.getEstimatedHeightForRow()
        
        // Avoid gaps between sections and custom section headers
        table.sectionFooterHeight = 0
        
        // Enable self-sizing of section headers according to their subviews auto layout (must not be 0)
//        table.estimatedSectionHeaderHeight = 60
        
//        table.tableHeaderView
//        // These two lines avoid constraints' conflict of header and its label when view just loaded
//        table.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
//        table.tableHeaderView?.fillSuperview()
        
        return table
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredCustomFontWith(weight: .semibold, size: 19)
        label.textColor = UIColor.label
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Utils.customBackgroundColor
        contentView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        contentView.addSubview(resultsTable)
        resultsTable.dataSource = self
        resultsTable.delegate = self
                
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func applyConstraints() {
        resultsTable.translatesAutoresizingMaskIntoConstraints = false
        resultsTable.fillSuperview()
    }

        
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchResultsCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30 // hardcoded number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCell.identifier, for: indexPath) as? SearchResultsTableViewCell else { return UITableViewCell() }
        
        if indexPath.row == 2 {
            cell.configureFor(book: Book.book20)
        } else if indexPath.row == 4 {
            cell.configureFor(book: Book.book22)
        } else if indexPath.row == 5 {
            cell.configureFor(book: Book.book23)
        } else if indexPath.row == 7 {
            cell.configureFor(book: Book.book21)
        } else {
            cell.configureFor(book: Book.book3)
        }
        
//        cell.configureFor(book: Book.book)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return SearchResultsTableViewCell.getEstimatedHeightForRow()
//    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("estimatedheight: \(SearchResultsTableViewCell.getEstimatedHeightForRow())")
        return SearchResultsTableViewCell.getEstimatedHeightForRow()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt \(indexPath.row)")
    }

        
}
