//
//  SearchResultsCollectionViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 11/3/23.
//

import UIKit

protocol SearchResultsCollectionViewCellDelegate: AnyObject {
    
    func searchResultsCollectionViewCell(_ searchResultsCollectionViewCell: SearchResultsCollectionViewCell, withButtonKind buttonKind: ButtonKind, hasOffset offset: CGPoint)
}

let tableDidRequestKeyboardDismiss = Notification.Name(
    rawValue: "tableDidRequestKeyboardDismiss")

class SearchResultsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchResultsCollectionViewCell"
    
    weak var delegate: SearchResultsCollectionViewCellDelegate?
    
    var itemSelectedCallback: ItemSelectedCallback = {_ in}
        
    private var isFirstTime = true
    
    var rememberedOffset: CGPoint = CGPoint(x: 0, y: 0)
    
    var buttonKind: ButtonKind?
    
    let resultsTable: UITableView = {
//        let table = UITableView(frame: .zero, style: .grouped)
        let table = UITableView(frame: .zero, style: .plain)

        table.backgroundColor = Utils.customBackgroundColor
        table.separatorColor = UIColor.clear
        
        // Avoid gap at the very bottom of the table view
//        let inset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
//        table.contentInset = inset
        
        table.register(SearchResultsBookTableViewCell.self, forCellReuseIdentifier: SearchResultsBookTableViewCell.identifier)
        table.register(SearchResultsSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchResultsSectionHeaderView.identifier)
        
        table.rowHeight = UITableView.automaticDimension
//        table.estimatedRowHeight = SearchResultsTableViewCell.getEstimatedHeightForRow()
        
        table.sectionHeaderHeight = UITableView.automaticDimension
        // Avoid gap above custom section header
        table.sectionHeaderTopPadding = 0
        
        return table
    }()
    
    var isBeingReused = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Utils.customBackgroundColor
        contentView.addSubview(resultsTable)
        resultsTable.dataSource = self
        resultsTable.delegate = self
        applyConstraints()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if resultsTable.contentOffset != rememberedOffset {
            resultsTable.contentOffset = rememberedOffset
//            print("offsetY of cell \(String(describing: buttonKind?.rawValue)) is set to \(rememberedOffset.y)")
        }
    }
    
    private func applyConstraints() {
        resultsTable.translatesAutoresizingMaskIntoConstraints = false
        resultsTable.fillSuperview()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        print("prepareForReuse")
        isBeingReused = true
    }
    
    // MARK: - Helper methods
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesure))
        tapGesture.cancelsTouchesInView = false
        resultsTable.addGestureRecognizer(tapGesture)
    }

    @objc func handleTapGesure() {
        NotificationCenter.default.post(name: tableDidRequestKeyboardDismiss, object: nil)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchResultsCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30 // hardcoded number
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsBookTableViewCell.identifier, for: indexPath) as? SearchResultsBookTableViewCell else { return UITableViewCell() }
        
//        print("tvcell for \(String(describing: buttonKind?.rawValue)) configured")
        guard let buttonKind = buttonKind else { return UITableViewCell() }
        
        switch buttonKind {
        case .top: cell.configureFor(book: Book.book20)
        case .books: cell.configureFor(book: Book.book22)
        case .authors: cell.configureFor(book: Book.book23)
        case .narrators: cell.configureFor(book: Book.book21)
        case .series: cell.configureFor(book: Book.book3)
        case .tags: cell.configureFor(book: Book.book1)
        }
        
//        if indexPath.row == 2 {
//            cell.configureFor(book: Book.book20)
//        } else if indexPath.row == 4 {
//            cell.configureFor(book: Book.book22)
//        } else if indexPath.row == 5 {
//            cell.configureFor(book: Book.book23)
//        } else if indexPath.row == 7 {
//            cell.configureFor(book: Book.book21)
//        } else {
//            cell.configureFor(book: Book.book3)
//        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchResultsBookTableViewCell.getEstimatedHeightForRow()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt \(indexPath.row)")
        itemSelectedCallback(Book.book1)
        #warning("Change argument value to real one")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchResultsSectionHeaderView.identifier) as? SearchResultsSectionHeaderView else { return UIView() }

        if let buttonKind = buttonKind {
            header.configureFor(buttonKind: buttonKind)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return SearchResultsSectionHeaderView.calculateEstimatedHeaderHeight()
    }

}

// MARK: - UIScrollViewDelegate
extension SearchResultsCollectionViewCell {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: tableDidRequestKeyboardDismiss, object: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging || scrollView.isDecelerating {
//            print("cell \(buttonKind) scrollView.isDragging || scrollView.isDecelerating ")
            guard let buttonKind = buttonKind else { return }
            delegate?.searchResultsCollectionViewCell(self, withButtonKind: buttonKind, hasOffset: scrollView.contentOffset)
        }
    }
    
}


